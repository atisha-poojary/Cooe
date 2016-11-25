//
//  InvitedCustomCell.swift
//  Coo-e
//
//  Created by Atisha Poojary on 19/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class InvitedCustomCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var invitedBy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}