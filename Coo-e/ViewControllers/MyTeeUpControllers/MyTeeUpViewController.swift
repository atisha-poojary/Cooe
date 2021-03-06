//
//  MyTeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 17/10/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyTeeUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var invitesUnderlined:UILabel!
    @IBOutlet weak var coordinatingUnderlined:UILabel!
    @IBOutlet weak var pastUnderlined:UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var no_teeUp_message: UILabel!
    var myTeeupArray: NSArray = []
    var isCategory : String!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FIRAuth.auth()?.signIn(withEmail: "hazard1@srihari.guru", password: "password") { (user, error) in
            print(user!)
        }
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        invitesUnderlined.isHidden=true
        coordinatingUnderlined.isHidden=false
        pastUnderlined.isHidden=true
        self.tableView.isHidden=true
        isCategory = "Coordinating"
        
        no_teeUp_message.text = ""
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MyTeeUpViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.getMyTeeups(category: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func isTeeUpCategory(_ sender: UIButton) {
        let buttonTag = sender.tag
        self.tableView.isHidden=true
        no_teeUp_message.isHidden = true

        if(buttonTag == 0){
            invitesUnderlined.isHidden=false
            coordinatingUnderlined.isHidden=true
            pastUnderlined.isHidden=true
            
            isCategory = "Invities"
            self.getMyTeeups(category: "invites")
         }
            
        else if(buttonTag == 1){
            coordinatingUnderlined.isHidden=false
            invitesUnderlined.isHidden=true
            pastUnderlined.isHidden=true

            isCategory = "Coordinating"
            self.getMyTeeups(category: "")
        }
        else if(buttonTag == 2){
            pastUnderlined.isHidden=false
            coordinatingUnderlined.isHidden=true
            invitesUnderlined.isHidden=true

            isCategory = "Past"
            self.getMyTeeups(category: "past")
        }
    }
    
    func getMyTeeups(category: String)
    {
        let urlString = ("http://69.164.208.35:8080/api/teeups/\(category)")
        let url: URL = URL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in 
            
            if error != nil {
              ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
                return
            }
            
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            //using local data
//            let url = Bundle.main.url(forResource: "data", withExtension: "json")
//            let data = NSData(contentsOf: url!)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    if let status = dict["status"] as? Int {
                        DispatchQueue.main.async{
                            if status == 200 {
                                self.myTeeupArray = (dict["teeups"] as? NSArray)!
                                if self.myTeeupArray.count == 0 {
                                    self.tableView.isHidden = true
                                    self.no_teeUp_message.isHidden = false
                                    
                                    if self.isCategory == "Invities"{
                                        self.no_teeUp_message.text = "You haven't been invited to anything yet, try creating a TeeUp with your friends."
                                    }
                                    if self.isCategory == "Coordinating"{
                                        self.no_teeUp_message.text = "You're not coordinating anything yet, try creating a TeeUp with your friends."
                                    }
                                    else if self.isCategory == "Past"{
                                        self.no_teeUp_message.text = "There is no past event, try creating a TeeUp with your friends."
                                    }
                                }
                                else {
                                    self.no_teeUp_message.isHidden = true
                                    self.tableView.isHidden = false
                                    self.tableView.estimatedRowHeight = 130;
                                    self.tableView.rowHeight = UITableViewAutomaticDimension;
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                    return
                }
            } catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if self.myTeeupArray.count != 0{
            return self.myTeeupArray.count
        }
        else {return 0}
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        let cell:InvitedCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "InvitedCustomCell") as! InvitedCustomCell!)
        
        let teeupDict = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject)
        
        if(isCategory == "Invities"){
            let cell:InvitedCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "InvitedCustomCell") as! InvitedCustomCell!)
            
            if self.myTeeupArray.count != 0 {
                cell.title.text = teeupDict.object(forKey: "title") as? String
                
                if let message = teeupDict.object(forKey: "message") as? String{
                    cell.message.text = message
                }
                
                let invitedByString = "\(((teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "firstName") as? String)!) invited you and \((teeupDict.object(forKey: "participants") as! NSArray).count - 2) others."
                cell.invitedBy.text = invitedByString
                
                if let profilePicId = (teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "profilePicId") as? String {
                    cell.profilePicture.imageFromID(urlString:"http://69.164.208.35:8080/api/image/\(profilePicId)")
                }
                else{
                    cell.profilePicture.image = UIImage(named: "profile_pic.png")
                }
                
                if let gamePlanWhen = teeupDict.object(forKey: "gamePlanWhen") as? NSDictionary {
                    let time = gamePlanWhen.object(forKey: "fromDate") as? String
                    cell.whereLabel.text = time
                    cell.whereLabel.adjustsFontSizeToFitWidth = true
                }else{
                    cell.whereLabel.text = "No time set"
                }
                
                
                if let gamePlanWhere = teeupDict.object(forKey: "gamePlanWhere") as? NSDictionary {
                    let location = gamePlanWhere.object(forKey: "locationName") as? String
                    cell.whereLabel.text = location
                    cell.whereLabel.adjustsFontSizeToFitWidth = true
                }else{
                    cell.whereLabel.text = "No location set"
                }
            }
            return cell
        }
        else if(isCategory == "Coordinating"){
            let cell:CoordinatingCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "CoordinatingCustomCell") as! CoordinatingCustomCell!)
            if self.myTeeupArray.count != 0 {
                cell.title.text = teeupDict.object(forKey: "title") as? String
                
                if let message = teeupDict.object(forKey: "message") as? String{
                    cell.message.text = message
                }

                if let profilePicId = (teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "profilePicId") as? String {
                    cell.profilePicture.imageFromID(urlString:"http://69.164.208.35:8080/api/image/\(profilePicId)")
                }
                else{
                    cell.profilePicture.image = UIImage(named: "profile_pic.png")
                }
                
                let createdByString = "Created by \(((teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "firstName") as? String)!) \(((teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "lastName") as? String)!)"
                cell.createdByLabel.text = createdByString
                

                let teeupStatus = self.getTeeupStatus((teeupDict.object(forKey: "status") as? Int)!)
                cell.teeupStatus.text = teeupStatus
                cell.userStatus_icon.image = UIImage(named: "\(teeupStatus).png")
                
                var goingCount = 0
                var invitedCount = 0
                
                for j in 0..<(teeupDict.object(forKey: "participants") as! NSArray).count{
                    if let userId = ((teeupDict.object(forKey: "participants") as! NSArray).object(at: j) as AnyObject).object(forKey: "userId") as? String {
                        if userId == UserDefaults.standard.string(forKey: "id")! {
                            let userStatus = self.getUserStatus(((teeupDict.object(forKey: "participants") as! NSArray).object(at: j) as AnyObject).object(forKey: "status") as! Int)
                            cell.userStatus.text = userStatus
                            cell.userStatus_icon.image = UIImage(named: "\(userStatus).png")
                        }
                    }
                    
                    if let userStatus = ((teeupDict.object(forKey: "participants") as! NSArray).object(at: j) as AnyObject).object(forKey: "status") as? Int{
                        if userStatus == 0{
                            invitedCount += 1
                        }
                        if userStatus == 2{
                            goingCount += 1
                        }
                    }
                }
                
                cell.numberOfPeopleGoing.text = "\(goingCount) going"
                cell.numberOfPeopleInvited.text = "\(invitedCount) invited"

                if let gamePlanWhen = teeupDict.object(forKey: "gamePlanWhen") as? NSDictionary {
                    let time = gamePlanWhen.object(forKey: "fromDate") as? String
                    cell.whereLabel.text = time
                    cell.whereLabel.adjustsFontSizeToFitWidth = true
                }else{
                    cell.whereLabel.text = "No time set"
                }
                
                
                if let gamePlanWhere = teeupDict.object(forKey: "gamePlanWhere") as? NSDictionary {
                    let location = gamePlanWhere.object(forKey: "locationName") as? String
                    cell.whereLabel.text = location
                    cell.whereLabel.adjustsFontSizeToFitWidth = true
                }else{
                    cell.whereLabel.text = "No location set"
                }
            }
            return cell
        }
        else if(isCategory == "Past"){
            let cell:ArchiveCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "ArchiveCustomCell") as! ArchiveCustomCell!)
            if self.myTeeupArray.count != 0 {
                cell.title.text = teeupDict.object(forKey: "title") as? String
                
                if let profilePicId = (teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "profilePicId") as? String {
                    cell.profilePicture.imageFromID(urlString:"http://69.164.208.35:8080/api/image/\(profilePicId)")
                }
                else{
                    cell.profilePicture.image = UIImage(named: "profile_pic.png")
                }
                
                let createdByString = "Created by \(((teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "firstName") as? String)!) \(((teeupDict.object(forKey: "creator") as AnyObject).object(forKey: "lastName") as? String)!)"
                cell.createdByLabel.text = createdByString
                
                let teeupStatus = self.getTeeupStatus((teeupDict.object(forKey: "status") as? Int)!)
                cell.teeupStatus.text = teeupStatus
                cell.userStatus_icon.image = UIImage(named: "\(teeupStatus).png")
                
                var goingCount = 0
                var invitedCount = 0
                
                for j in 0..<(teeupDict.object(forKey: "participants") as! NSArray).count{
                    if let userId = ((teeupDict.object(forKey: "participants") as! NSArray).object(at: j) as AnyObject).object(forKey: "userId") as? String {
                        if userId == UserDefaults.standard.string(forKey: "id")! {
                            let userStatus = self.getUserStatus(((teeupDict.object(forKey: "participants") as! NSArray).object(at: j) as AnyObject).object(forKey: "status") as! Int)
                            cell.userStatus.text = userStatus
                            cell.userStatus_icon.image = UIImage(named: "\(userStatus).png")
                        }
                    }
                    
                    if let userStatus = ((teeupDict.object(forKey: "participants") as! NSArray).object(at: j) as AnyObject).object(forKey: "status") as? Int{
                        if userStatus == 0{
                            invitedCount += 1
                        }
                        if userStatus == 2{
                            goingCount += 1
                        }
                    }
                }
                
                cell.numberOfPeopleWent.text = "\(goingCount) going"
                cell.numberOfPeopleInvited.text = "\(invitedCount) invited"
                
                if let gamePlanWhen = teeupDict.object(forKey: "gamePlanWhen") as? NSDictionary {
                    let time = gamePlanWhen.object(forKey: "fromDate") as? String
                    cell.whereLabel.text = time
                    cell.whereLabel.adjustsFontSizeToFitWidth = true
                }else{
                    cell.whereLabel.text = "No time set"
                }
                
                
                if let gamePlanWhere = teeupDict.object(forKey: "gamePlanWhere") as? NSDictionary {
                    let location = gamePlanWhere.object(forKey: "locationName") as? String
                    cell.whereLabel.text = location
                    cell.whereLabel.adjustsFontSizeToFitWidth = true
                }else{
                    cell.whereLabel.text = "No location set"
                }

            }
            return cell
        }
        return cell
    }
    
    func getTeeupStatus(_ status: Int) -> String{
        switch status {
        case 0:
            return "Planning"
        case 1:
            return "It's On"
        case 2:
            return "Happening"
        case 3:
            return "It's Ended"
        case 4:
            return "Cancelled"
        default:
            break
        }
        return ""
    }
    
    func getUserStatus(_ status: Int) -> String{
        switch status {
        case 0:
            return "Invited"
        case 1:
            return "Might go"
        case 2:
            return "I'm going"
        case 3:
            return "Interested"
        case 4:
            return "Not going"
        case 5:
            return "On my way"
        case 6:
            return "Arrived"
        default:
            break
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(isCategory == "Invities"){
            return 132.0;
        }
        else if(isCategory == "Coordinating"){
            return 132.0;
        }
        else if(isCategory == "Past"){
            return 132.0;
        }
        return 0.0;//Choose your custom row height
    }
    
    func refresh(_ sender:AnyObject){
        if Reachability()?.modifiedReachabilityChanged() == true {
            if(isCategory == "Invities"){ self.getMyTeeups(category: "invites")}
            if(isCategory == "Coordinating"){ self.getMyTeeups(category: "")}
            if(isCategory == "Past"){ self.getMyTeeups(category: "past")}
        }
        else{
            ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: view.frame.size.height-85)
        }
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeeUpViewController") as! TeeUpViewController
    
        vc.teeUp_id = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "id") as? String
        
        vc.hidesBottomBarWhenPushed = true
        
        self.title = ""
        self.navigationItem.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.show(vc, sender: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "TeeUps"
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
}

