//
//  ParticipantsViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 08/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class ParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var participantsArray: NSArray!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var participantsScrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "People"
        self.addParticipantsToScrollView(self.participantsArray.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addParticipantsToScrollView(_ numberOfParticipants: Int) {
        
        for i in 0..<numberOfParticipants {
            
            let participantView = UIView(frame: CGRect(x: i*80 + 10, y: 10, width: 70, height: 70))
            self.participantsScrollView.addSubview(participantView)
            
            let statusOfParticipantImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            
            let profilePicture = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            //change to the url you get from the response
            profilePicture.imageFromUrl(urlString: "http://scontent.cdninstagram.com/t51.2885-19/s150x150/15276748_1238248896241231_7045268600633950208_a.jpg")
            profilePicture.setRounded()
            
            switch (participantsArray.object(at: 0) as AnyObject).object(forKey: "status") as! Int {
            case 0:
                statusOfParticipantImageView.image = UIImage(named: "going.png")
            case 1:
                statusOfParticipantImageView.image = UIImage(named: "invited.png")
            case 2:
                statusOfParticipantImageView.image = UIImage(named: "interested.png")
            case 3:
                statusOfParticipantImageView.image = UIImage(named: "going.png")
            case 4:
                statusOfParticipantImageView.image = UIImage(named: "on my way.png")
            case 4:
                statusOfParticipantImageView.image = UIImage(named: "going.png")
                
            default:
                break
            }
            participantView.addSubview(profilePicture)
            participantView.addSubview(statusOfParticipantImageView)
        }
    }

    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if self.participantsArray != nil{
            return self.participantsArray.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ParticipantsCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "ParticipantsCustomCell") as! ParticipantsCustomCell!)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //change to the url you get from the response
        cell.profilePicture.imageFromUrl(urlString: "http://scontent.cdninstagram.com/t51.2885-19/s150x150/15276748_1238248896241231_7045268600633950208_a.jpg")
        
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
