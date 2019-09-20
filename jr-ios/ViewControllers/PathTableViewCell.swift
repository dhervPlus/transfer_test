//
//  PathTableViewCell.swift
//  jr-ios
//
//  Created by damien on 2019/09/02.
//  Copyright © 2019 beacrew. All rights reserved.
//

import UIKit

class PathTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var informationBoard: UILabel!
    
    var current_table = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
