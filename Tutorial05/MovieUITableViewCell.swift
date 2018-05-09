//
//  MovieUITableViewCell.swift
//  Tutorial05
//
//  Created by Hua Cai on 9/5/18.
//  Copyright © 2018 Hua Cai. All rights reserved.
//

import UIKit

class MovieUITableViewCell: UITableViewCell {

    @IBOutlet weak var subTileLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
