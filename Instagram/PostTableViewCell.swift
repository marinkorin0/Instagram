//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 小林真理子 on 2017/03/24.
//  Copyright © 2017年 小林真理子. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate {
    func commentButton_Clicked(post: PostData)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
   
    
    var delegate:PostTableViewCellDelegate!
    var post: PostData!{
        didSet{
            
        }
    }
    
    
    
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
        
        self.captionLabel.text = "\(postData.name!): \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyy-MM-dd HH:mm"
        
        
        let dateString:String = formatter.string(from: postData.date! as Date)
        self.dateLabel.text = dateString
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
            
        }
        
        }
    
    @IBAction func commentButton(_ sender: Any) {
    }
   
    
    
    }
    

