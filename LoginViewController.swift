//
//  LoginViewController.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/17.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var mailAddressTextField: UITextField! //メアド
    @IBOutlet weak var passwordTextField: UITextField! //パスワード
    @IBOutlet weak var displayNameTextField: UITextField! //アカウント作成時は表示名を入力
    
    //ログイン
    @IBAction func handleLoginButton(_ sender: Any) {
    
        if let adress = mailAddressTextField.text, let password = passwordTextField.text {
            
            //必要項目を入力して下さい！を表示．adress,passwordが入力されない時は何もせずエラー表示...showErrorを使う時はdismissは不要で、勝手に消えてくれるみたい．
            if adress.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            
            //HUD(Head Up Display)で処理中を表示...showメソッドとdismiss(表示終了)はセットで使うみたい．
            SVProgressHUD.show()
            
            FIRAuth.auth()?.signIn(withEmail: adress, password: password) { user, error in
                if let error = error {
                    print("DEBUG_PRINt: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                } else {
                    print("DEBUG_PRONT: ログインに成功しました")
                    
                    //HUD(Head Up Display)表示終了...showメソッドとdismiss(表示終了)はセット．
                    SVProgressHUD.dismiss()
                    
                    //画面を閉じてViewCOntrollerに戻る
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //アカウント作成
    @IBAction func handleCreateAcountButton(_ sender: AnyObject) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            
            // Email,Password,表示名がEmptyの時は何もしない．showErrorで表示して勝手に終了する(dismissは不要)
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //HUD(Head Up Display)で処理中を表示...showメソッドはdismiss(表示終了)とセットで使う
            SVProgressHUD.show()
            
            // Email,Passwordでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            FIRAuth.auth()?.createUser(withEmail: address, password: password) { user, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnする. 以降の処理は実行せずに終了．
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                // 表示名を設定する
                let user = FIRAuth.auth()?.currentUser
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            SVProgressHUD.showError(withStatus: "ユーザー作成時にエラーが発生しました")
                            print("DEBUG_PRINT: " + error.localizedDescription)
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName)]の設定に成功しました。")
                        
                        //HUDを消す．showとdismissセットね．
                        SVProgressHUD.dismiss()
                
                        // 画面を閉じてViewControllerに戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("DEBUG_PRINT: displayNameの設定に失敗しました。")
                }
            }
        }
            
            
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
