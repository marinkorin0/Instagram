//
//  PostData.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/24.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    var comment: String?//コメント用に足しましたー
   
    
    
    //データの追加や更新があるとFIRDataSnapshotクラスとして渡す
    init(snapshot: FIRDataSnapshot, myId: String){
        self.id = snapshot.key
        //keyプロパティが要素自身のIDとなる
        
        //さっき、postViewControllerのところで投稿と保存しました．valueプロパティーにデータが入っていてkeyとの組み合わせで辞書型になっている．keyはStringなのでvalueDictionary["name"]などの値で取り出します．
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.name = valueDictionary["name"] as? String
        self.caption = valueDictionary["caption"] as? String
        let time = valueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
      
        //コメント用に足しましたー
        self.comment = valueDictionary["comment"]as? String
        
        
        //isLikedプロパティだけはFIRDataSnapshotから取り出すのではなくlikesでString型配列から取り出します．
        if let likes = valueDictionary["likes"] as? [String]{
            self.likes = likes
        }
        
        //ユーザー自身のIDが入っているかtrueかfalseで設定
        for likeID in self.likes {
            if likeID == myId {
                self.isLiked = true
                break
            }
        }
        
    }
}
