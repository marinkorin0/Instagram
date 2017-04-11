//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/24.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit

//protcol viewcontrollerの上でcellなどをdelegateする時、このほかのviewcontrollerからこのdelegateを呼び出せるようにする．
protocol PostTableViewCellDelegate {
    //コメントボタンが押された時、
    func commentButton_Clicked(post: PostData)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
   //コメント用に足しました．
    @IBOutlet weak var commentButton: UIButton!
    
    //
    var delegate: PostTableViewCellDelegate!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setPostData(postData: PostData){
        self.postImageView.image = postData.image
        
    
        //キャプションラベルには、名前とキャプションを表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        
        
        //likeラベルには数を入れる
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        
        
        //日時設定の表示、DateFormatterクラスを生成し、localプロパティにNSLocalクラスを設定します．
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyy-MM-dd HH:mm"
        
        
        let dateString:String = formatter.string(from: postData.date! as Date)
        self.dateLabel.text = dateString
        
        
        //likeした時の表示．UIButtonクラスのsetImageメソッドにlikeした時はUIImageのlike_exist(ピンク)、likeじゃない時は、like_none(青)を設定しました．
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
            
        }
        
        
        }
    
  

       
    
    }
    

