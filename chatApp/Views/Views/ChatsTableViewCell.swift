//
//  ChatsTableViewCell.swift
//  chatApp
//
//  Created by Ronald Kimutai on 28/01/2018.
//  Copyright © 2018 Ronald Kimutai. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    var icon: UIImageView = UIImageView()
    var nameLabel: UILabel = UILabel()
    var msisdnLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(msisdnLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        icon.contentMode = UIViewContentMode.scaleAspectFit
        icon.backgroundColor = UIColor.buttonColor.defaultButtonColor
        icon.layer.cornerRadius = 25
        icon.clipsToBounds = true
        icon.tintColor = .black
        
        nameLabel.frame = CGRect(x: icon.frame.origin.x + icon.frame.size.width + 15, y: 10, width: self.bounds.width - 10, height: 30)
        nameLabel.textColor = UIColor.black
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0))
        
        msisdnLabel.frame = CGRect(x: icon.frame.origin.x + icon.frame.size.width + 15, y: nameLabel.frame.size.height + nameLabel.frame.origin.y + 5, width: self.bounds.width - 10, height: 30)
        msisdnLabel.textColor = UIColor.black
        msisdnLabel.backgroundColor = UIColor.clear
        msisdnLabel.textAlignment = NSTextAlignment.left
        msisdnLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        msisdnLabel.numberOfLines = 0
        msisdnLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0))
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
