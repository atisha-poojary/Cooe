//
//  ArchiveCustomCell.swift
//  Coo-e
//
//  Created by Atisha Poojary on 19/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class ArchiveCustomCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var teeupStatus: UILabel!
    @IBOutlet weak var teeupStatus_icon: UIImageView!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userStatus_icon: UIImageView!
    @IBOutlet weak var numberOfPeopleWent: UILabel!
    @IBOutlet weak var numberOfPeopleInvited: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var eventStatusView: UIView!
    @IBOutlet weak var myStatusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicture.setRounded()
        eventStatusView.setRoundedCorners()
        myStatusView.setRoundedCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
