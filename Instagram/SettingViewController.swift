//
//  SettingViewController.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/17.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD


class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //表示名の変更
    @IBAction func handleChangeButton(_ sender: AnyObject) {
        if let displayName = displayNameTextField.text {
            
            //表示名が入力されていない時、HUDを出すだけ
            if displayName.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            
            //表示名を設定
            let user = FIRAuth.auth()?.currentUser
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("DEBUG_PRINT:" + error.localizedDescription)
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName)]の設定に成功しました。")
                
                }
            }
            //キーボードを閉じる
            self.view.endEditing(true)
        }
    }
    
    //ログアウト
    @IBAction func handleLogoutButton(_ sender: AnyObject) {
    //ログアウトする
        try! FIRAuth.auth()?.signOut()
        
        //ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        //ログイン画面から戻った時、ホーム画面(index = 0)を選択している状態にしておく
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //表示名を取得し設定
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
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
