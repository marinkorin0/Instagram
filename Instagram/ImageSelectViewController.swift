//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/17.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate {
    
    //写真を、ライブラリあるいはカメラ撮影して選択する画面．アドビの画像加工の画面．加工写真はPostViewControllerのimageに置く
    //ライブラリbtn
    @IBAction func handleLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }

    //カメラbtn
    @IBAction func handleCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated:true, completion: nil)
        }
    }
    
    
    //キャンセル （画面を閉じる）
    @IBAction func handleCancelButton(_ sender: Any) {
      self.dismiss(animated: true,completion: nil)
    }
    
    //写真を撮影/選択した時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // あとでAdobeUXImageEditorを起動する
            // AdobeUXImageEditorで、受け取ったimageを加工できる
            // ここでpresentViewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            DispatchQueue.main.async {
                // AdobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.present(adobeViewController, animated: true, completion:  nil)
            }
        }
        // 閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    // フォトライブラリやカメラ起動中にキャンセルされたときに呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    // Adobeで、画像加工...AdobeImageEditorで加工が終わった時
    func photoEditor(_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
        // 加工後、投稿画面をpostviewcontrollerのimageに置く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image
        present(postViewController, animated: true, completion: nil)
    }
    
    
    // 加工をキャンセル...AdobeImageEditorで加工をキャンセルした時
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


