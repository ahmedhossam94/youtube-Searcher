//
//  SearchCell.swift
//  Awstream Task
//
//  Created by ahmed on 3/20/19.
//  Copyright © 2019 Ahmed Hossam. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
