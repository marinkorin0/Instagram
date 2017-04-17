//
//  HomeViewController.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/17.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    //FireDatabadeのobserveEventの登録状態
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //テーブルセルのタップを無効
        tableView.allowsSelection = false
        
        
        //PostTableViewCellを指定して初期化．
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")//Outletで接続しているTableViewにRegisterNibで設定．IdentifireはCell.
        tableView.rowHeight = UITableViewAutomaticDimension//rowHeightに設定しているUITableViewAutomaticDimensionはセルの高さをAutolayoutに任せる．
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if FIRAuth.auth()?.currentUser != nil{
            if self.observing == false{
                //投稿されたら(要素が追加されたら)、postArrayに追加して再表示(TableView)
                let postsRef = FIRDatabase.database().reference().child(Const.PostPath)
                
                postsRef.observe(.childAdded, with:{ snapshot in print("DEBUG_PRINT: .childAddedイベントが発生しました")
                    
                    //postDataクラスを生成して、受け取ったデータを設定
                    if let uid = FIRAuth.auth()?.currentUser?.uid{
                        let postData = PostData(snapshot: snapshot, myId:uid)
                        self.postArray.insert(postData, at: 0)
                        
                        //TableViewを再表示
                        self.tableView.reloadData()
                        
                    }
                    
                })
                //いいねの数が増えた時(要素が変更されたら)該当データをpostArrayから一度削除し新たなデータを追加して　TableViewに再表示
                postsRef.observe(.childChanged, with:{snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました")
                    
                    //PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        //保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray{
                            if post.id == postData.id {
                                index = self.postArray.index(of: post)!
                                break
                                
                            }
                        }
                        //差し変えるため一度削除
                        self.postArray.remove(at: index)
                        
                        //削除後、新データを追加する
                        self.postArray.insert(postData, at: index)
                        
                        //TabkeViewの表示を更新
                        self.tableView.reloadData()
                        
                    }
                })
                
                //FIDatabaseのobserveEventが上記コードにより登録されたため
                //trueとする
                observing = true
            }
        }else{
            if observing == true{
                
                
                //ログアウトを検出したら、オブザーバーを削除
                //一旦テーブルをクリアしてから
                postArray = []
                tableView.reloadData()
                //オブザーバーを削除
                FIRDatabase.database().reference().removeAllObservers()
                
                //FIRDatabaseのobserveEventが上記コードにより解除されたため
                //falseとする
                observing = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cellを取得して、データを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostData(postData: postArray[indexPath.row])
        
        //cellのアクションを、ソースコードで設定
        cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        
        //コメント用．cellのアクションをソースコードで設定
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(sender:event:)), for: .touchUpInside)
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //auto layoutでcellの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        //cellをタップしたら　選択状態を解除する(もしタップしたときに画像を拡大して表示するなどさせる場合にはここに記述する)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    
    // cell内のボタンがタップされた時のアクション
    func handleButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        
        // タップされたcellのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // タップされた列のインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        // Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if postData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
        }
        
        // 増えたlikesをFirebaseに保存する
        let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!)
        let likes = ["likes": postData.likes]
        postRef.updateChildValues(likes)
        
    }

    // コメント用　cell内のボタンがタップされた時のアクション
    func handleCommentButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: commentボタンがタップされました。")
        
        // タップされたcellのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        override func prepare(for: <#T##UIStoryboardSegue#>, sender: <#T##Any?#>)
        // segueから遷移先のcommentViewControllerを取得する
        let commentViewController:CommentViewController = segue.destination as! CommentViewController
        //遷移先のcommentViewControllerで宣言しているpostData型
        var postData: PostData!
    }

    
    
    }

