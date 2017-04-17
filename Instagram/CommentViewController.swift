//
//  CommentViewController.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/04/08.
//  Copyright © 2017年 小林真理子. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class CommentViewController: UIViewController, UITableViewDelegate {
    
    //IBOutletで接続
    @IBOutlet weak var commentTextField: UITextField!//コメント入力欄
    
    //受け取るためのプロパティー(変数)を宣言
    var postData: PostData!
    
    //コメント投稿したら呼ばれるメソッド(PostViewControllerの...投稿してFirebaseに保存...のところにあったやつ...)
    @IBAction func handleCommentButton(_ sender: Any) {
        //postDataに必要な情報を取得しておく
        let name = FIRAuth.auth()?.currentUser?.displayName
        
        //辞書を作ってFirebaseに保存する
        let postRef = FIRDatabase.database().reference().child(Const.PostPath)
        let postData = ["name": name!, "caption": commentTextField.text!]
        postRef.childByAutoId().setValue(postData)
        
        //HUD で投稿完了を表示
        SVProgressHUD.showSuccess(withStatus: "コメント投稿しました")
        
        // 全てのモーダルを閉じる
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


