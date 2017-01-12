//
//  ParticipantsCustomCell.swift
//  Coo-e
//
//  Created by Atisha Poojary on 08/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class ParticipantsCustomCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.setRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
