//
//  SidePanelCell.swift
//  Coo-e
//
//  Created by Atisha Poojary on 13/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class SidePanelCell: UITableViewCell {
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
