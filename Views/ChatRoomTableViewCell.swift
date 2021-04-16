//
//  ChatRoomTableViewCell.swift
//  line.bot
//
//  Created by 酒井駿斗 on 2021/04/08.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {

    var  messageText: String?{
        didSet {
            guard let text = messageText else{return}
            let witdh = estimateFrameForTextView(text: text).width+20
            
            messageTextViewWidthConstraint.constant = witdh
            messageTextView.text = text
        }
    }
        
    
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    override  func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        messageTextView.layer.cornerRadius = 15
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func estimateFrameForTextView(text: String)-> CGRect{
        
        let size = CGSize(width: 200, height: 1000)
        let opnions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with:size,options: opnions,attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)],context:nil)
    }
}
