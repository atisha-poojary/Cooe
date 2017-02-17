//
//  TeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 03/12/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class TeeUpViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    var teeUp_id : String!
    @IBOutlet weak var teeUpTitleLabel:UILabel!
    
    var isteeUpOrIndividualStatusChanged = "changeTeeUpStatus"
    var lastTeeUpStatusSelected: String!
    var lastIndividualStatusSelected: String!
    var teeUpDictionary: NSDictionary!
    var whereSuggestionDictionary: NSDictionary!
    
    //@IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var teeUpStatusTable: UITableView!
    @IBOutlet weak var individualStatusTable: UITableView!
    @IBOutlet weak var teeUpStatusIcon: UIImageView!
    @IBOutlet weak var teeUpStatusLabel: UILabel!
    @IBOutlet weak var individualStatusIcon: UIImageView!
    @IBOutlet weak var individualStatusLabel: UILabel!
    @IBOutlet weak var participantsScrollView: UIScrollView!
    @IBOutlet weak var showDetailChatScreenButton: UIButton!
    @IBOutlet weak var showWhenSuggestion: UIButton!
    @IBOutlet weak var showWhereSuggestion: UIButton!
    @IBOutlet weak var when_like_countLabel:UILabel!
    @IBOutlet weak var when_dislike_countLabel:UILabel!
    @IBOutlet weak var where_like_countLabel:UILabel!
    @IBOutlet weak var where_dislike_countLabel:UILabel!
    @IBOutlet weak var goingCountLabel:UILabel!
    @IBOutlet weak var invitedCountLabel:UILabel!

    var teeUpStatusArray = ["Planning","It's on","Happening","It's ended","Cancelled"]
    var individualStatusArray = ["Invited","Might go","I'm going","Interested","Not going","On my way","Arrived"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerView.isHidden = true
        //datePicker.isHidden = true
        
        teeUpStatusTable.isHidden = true
        individualStatusTable.isHidden = true
        
        self.teeUpStatusTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.individualStatusTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        showDetailChatScreenButton.addTarget(self, action: #selector(showConversationScreen(_:)), for: .touchUpInside)
        showWhenSuggestion.addTarget(self, action: #selector(showWhenSuggestionScreen(_:)), for: .touchUpInside)
        showWhereSuggestion.addTarget(self, action: #selector(showWhereSuggestionScreen(_:)), for: .touchUpInside)
        
        self.getTeeUp(self.teeUp_id!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "TeeUp"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    func getTeeUp(_ teeUp_id: String)
    {
        let urlString = ("http://69.164.208.35:8080/api/teeups/\(teeUp_id)")
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
            
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    if let status = dict["status"] as? Int {
                        DispatchQueue.main.async{
                            if status == 200 {
                                self.teeUpDictionary = dict["teeup"] as! NSDictionary
                                self.teeUpTitleLabel.text = (dict["teeup"] as AnyObject).object(forKey: "title") as? String
                                
                                switch ((dict["teeup"] as AnyObject).object(forKey: "status") as? Int)! {
                                case 0:
                                    self.teeUpStatusLabel.text = "Planning"
                                case 1:
                                    self.teeUpStatusLabel.text = "It's On"
                                case 2:
                                    self.teeUpStatusLabel.text = "Happening"
                                case 3:
                                    self.teeUpStatusLabel.text = "It's Ended"
                                case 4:
                                    self.teeUpStatusLabel.text = "Cancelled"
                                    
                                default:
                                    break
                                }
                                
                                self.addParticipantsToScrollView(((dict["teeup"] as AnyObject).object(forKey: "participants") as! NSArray).count)
                               
                                if ((dict["teeup"] as AnyObject).object(forKey: "gamePlanWhenId") as? String) != nil{
                                    self.updateGamePlanWhen((self.teeUpDictionary["gamePlanWhen"] as! NSDictionary))
                                }
                                
                                if ((dict["teeup"] as AnyObject).object(forKey: "gamePlanWhereId") as? String) != nil{
                                    self.updateGamePlanWhere((self.teeUpDictionary["gamePlanWhere"] as! NSDictionary))
                                }
                            }
                                
                            else {
                                ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
                                return
                            }
                        }
                    }
                    return
                }
            }catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }
    
    func addParticipantsToScrollView(_ numberOfParticipants: Int) {
        
        var goingCount = 0
        var invitedCount = 0
        let participantsArray = self.teeUpDictionary["participants"] as! NSArray
        
        for i in 0..<numberOfParticipants {
            let participantView = UIView(frame: CGRect(x: i*80 + 10, y: 15, width: 70, height: 70))
            self.participantsScrollView.addSubview(participantView)
            
            //set picture
            let profilePicture = UIImageView(frame: CGRect(x: 5, y: 5, width: 60, height: 60))
            profilePicture.setRounded()
                        
            if let userInfoDict = ((participantsArray.object(at: i) as AnyObject).object(forKey: "userInfo")) as? NSDictionary {
                if let profilePicId = userInfoDict["profilePicId"]{
                    profilePicture.imageFromID(urlString: "http://69.164.208.35:8080/api/image/\(profilePicId as! String)")
                }
                else{
                    profilePicture.image = UIImage(named: "profile_pic.png")
                }
            }
            else{
                 profilePicture.image = UIImage(named: "profile_pic.png")
            }
 
            let statusOfParticipantImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            
            let viewParticipantsDetailScreenButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            viewParticipantsDetailScreenButton.addTarget(self, action: #selector(showParticipantsDetailScreen), for: .touchUpInside)
            
            //This updates the participant's status must be one of the following 0 = Invited, 1 = Might Go, 2 = I'm going, 3 = Interested, 4 = not going, 5 = on my way, 6 = arrived
            switch ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "status") as! Int {
            case 0:
                statusOfParticipantImageView.image = UIImage(named: "invited.png")
                invitedCount += 1
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "message.png")
                        individualStatusLabel.text = "Invited"
                    }
                }
                
            case 1:
                statusOfParticipantImageView.image = UIImage(named: "mightGo_circle.png")
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "mightGo_sym.png")
                        individualStatusLabel.text = "Might Go"
                    }
                }

            case 2:
                statusOfParticipantImageView.image = UIImage(named: "going.png")
                goingCount += 1
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "going_sym.png")
                        individualStatusLabel.text = "I'm Going"
                    }
                }

            case 3:
                statusOfParticipantImageView.image = UIImage(named: "interested.png")
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "interested_sym.png")
                        individualStatusLabel.text = "Interested"
                    }
                }
                
            case 4:
                statusOfParticipantImageView.image = UIImage(named: "notGoing_circle.png")
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "notGoing_sym.png")
                        individualStatusLabel.text = "Not Going"
                    }
                }

            case 5:
                statusOfParticipantImageView.image = UIImage(named: "on my way.png")
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "going_sym.png")
                        individualStatusLabel.text = "On My Way"
                    }
                }

            case 6:
                statusOfParticipantImageView.image = UIImage(named: "going.png")
                
                if let userId = ((self.teeUpDictionary["participants"] as! NSArray).object(at: i) as AnyObject).object(forKey: "userId") as? String{
                    if userId == UserDefaults.standard.string(forKey: "id")! {
                        individualStatusIcon.image=UIImage(named: "going_sym.png")
                        individualStatusLabel.text = "Arrived"
                    }
                }
                
            default:
                break
            }
            
            goingCountLabel.text = ("\(goingCount) Going")
            invitedCountLabel.text = ("\(invitedCount) Invited")
            
            participantView.addSubview(profilePicture)
            participantView.addSubview(statusOfParticipantImageView)
            participantView.addSubview(viewParticipantsDetailScreenButton)
        }
    }
    
    func updateGamePlanWhen(_ gamePlanWhenDict: NSDictionary){
        let date = gamePlanWhenDict.object(forKey: "fromDate")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: date as! String) {
            
            dateFormatter.dateFormat = "EEE, MMM d, yyyy-h:mm a"
            let stringOfDate = dateFormatter.string(from: date)
            showWhenSuggestion.setTitle(stringOfDate.replacingOccurrences(of: "-", with: "\n"),for: .normal)
            
            when_like_countLabel.text = "\((gamePlanWhenDict.object(forKey: "thumbsUpCount") as? Int)!)"
            
            when_dislike_countLabel.text = "\((gamePlanWhenDict.object(forKey: "thumbsDownCount") as? Int)!)"
        }
    }
    
    func updateGamePlanWhere(_ gamePlanWhereDict: NSDictionary){
        showWhereSuggestion.setTitle(gamePlanWhereDict.object(forKey: "locationName") as? String,for: .normal)
        
        where_like_countLabel.text = "\((gamePlanWhereDict.object(forKey: "thumbsUpCount") as? Int)!)"
        where_dislike_countLabel.text =
            "\((gamePlanWhereDict.object(forKey: "thumbsDownCount") as? Int)!)"
    }
    
    @IBAction func statusButtonClicked(_ sender: UIButton) {
        //pickerView.isHidden = false

        let buttonTag = sender.tag
        if buttonTag == 0{
            isteeUpOrIndividualStatusChanged = "changeTeeUpStatus"
            teeUpStatusTable.isHidden = false
            individualStatusTable.isHidden = true
            teeUpStatusTable.reloadData()
        }
        else {
            isteeUpOrIndividualStatusChanged = "changeIndividualStatus"
            individualStatusTable.isHidden = false
            teeUpStatusTable.isHidden = true
            individualStatusTable.reloadData()
        }
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus"{
            return self.teeUpStatusArray.count
        }
        else{
            return self.individualStatusArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = teeUpStatusTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus"{
            cell.textLabel?.text = self.teeUpStatusArray[indexPath.row]
        }
        else{
            let cell:UITableViewCell = individualStatusTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.textLabel?.text = self.individualStatusArray[indexPath.row]
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 30.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus" {
            if(indexPath.row == 0){
                teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
                teeUpStatusLabel.text = "Planning"
            }
            if(indexPath.row == 1){
                teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
                teeUpStatusLabel.text = "It's On"
            }
            if(indexPath.row == 2){
                teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
                teeUpStatusLabel.text = "Happening"
            }
            if(indexPath.row == 3){
                teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
                teeUpStatusLabel.text = "It's Ended"
            }
            if(indexPath.row == 4){
                teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
                teeUpStatusLabel.text = "Canceled"
            }
            teeUpStatusTable.isHidden = true
            self.updateStatus(indexPath.row)
        }
        else{
            if(indexPath.row == 0){
                individualStatusIcon.image = UIImage(named: "message.png")!
                individualStatusLabel.text = "Invited"
            }
            if(indexPath.row == 1){
                individualStatusIcon.image = UIImage(named: "mightGo_sym.png")
                individualStatusLabel.text = "Might Go"
            }
            if(indexPath.row == 2){
                individualStatusIcon.image = UIImage(named: "going_sym.png")
                individualStatusLabel.text = "I'm going"
            }
            if(indexPath.row == 3){
                individualStatusIcon.image = UIImage(named: "interested_sym.png")
                individualStatusLabel.text = "Interested"
            }
            if(indexPath.row == 4){
                individualStatusIcon.image = UIImage(named: "notGoing_sym.png")
                individualStatusLabel.text = "Not going"
            }
            if(indexPath.row == 5){
                individualStatusIcon.image = UIImage(named: "going_sym.png")
                individualStatusLabel.text = "On my way"
            }
            if(indexPath.row == 6){
                individualStatusIcon.image = UIImage(named: "going_sym.png")
                individualStatusLabel.text = "Arrived"
            }
            individualStatusTable.isHidden = true
            self.updateStatus(indexPath.row)
        }
    }
    
    func updateStatus(_ status:Int){
        var urlString: String
        if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus"{
            urlString = "http://69.164.208.35:8080/api/teeups/\(self.teeUp_id!)/updateStatus"
        }
        else{
            urlString = "http://69.164.208.35:8080/api/teeups/\(self.teeUp_id!)/updateUserStatus"
        }
        let url: NSURL = NSURL(string:urlString)!
        
        let params = ["status":status] as Dictionary<String, Any>
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
                })
                return
            }
            
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    
                    print("dict:'\(dict)")
                    
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
                        if let dict = json as? NSDictionary {
                            if let status = dict["status"] as? Int {
                                print("status: \(status)")
                                DispatchQueue.main.async{
                                    if status == 200 {
                                        print("Successfully updated status")
                                    }
                                    else{
                                        ModelController().showToastMessage(message: dict["message"] as! String, view: self.view, y_coordinate: self.view.frame.size.height-85)
                                    }
                                }
                            }
                            return
                        }
                        else {
                            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                            //postCompleted(succeeded: false, msg: "Error")
                        }
                    }
                }
                
            } catch let error as NSError {
                print("An error occurred: \(error)")
                
            }
        }
        task.resume()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.view.endEditing(true)
        teeUpStatusTable.isHidden = true
        individualStatusTable.isHidden = true
        //datePicker.isHidden = true
    }
  
    @IBAction func when_LikeDislike(_ sender: UIButton) {
        let buttonTag = sender.tag
        if buttonTag == 0{
        }
        else if buttonTag == 1{
        }
    }
    
    @IBAction func where_LikeDislike(_ sender: UIButton) {
        let buttonTag = sender.tag
        if buttonTag == 0{
        }
        else if buttonTag == 1{
        }
    }

    func showParticipantsDetailScreen(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParticipantsViewController") as! ParticipantsViewController
        vc.participantsArray = (self.teeUpDictionary["participants"] as! NSArray)
        vc.teeUpTitle = self.teeUpTitleLabel.text
        self.navigationItem.title = ""
        self.navigationController?.show(vc, sender: nil)
    }
    
    func showConversationScreen(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        print("self.teeUp_id! \(self.teeUp_id!)")
        vc.teeUp_id = self.teeUp_id!
        self.navigationController?.show(vc, sender: nil)
    }
    
    func showWhenSuggestionScreen(_ sender: UIButton) {
        if (self.teeUpDictionary["whenSuggestions"] as! NSArray).count == 0{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuggestWhenViewController") as! SuggestWhenViewController
            vc.teeUp_id = self.teeUp_id!
            self.navigationController?.show(vc, sender: nil)
        }
        else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhenSuggestionsViewController") as! WhenSuggestionsViewController
            vc.teeUp_id = self.teeUp_id!
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    func showWhereSuggestionScreen(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuggestWhereViewController") as! SuggestWhereViewController
        //vc.teeUp_id = self.teeUp_id!
        self.navigationController?.show(vc, sender: nil)
    }
    
    
    /*
     // MARK: - PickerView
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
     return 1
     }
     
     func pickerView(_ pickerView: UIPickerView,
     numberOfRowsInComponent component: Int) -> Int{
     if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus" {
     return teeUpStatusArray.count;
     }
     else {
     return individualStatusArray.count;
     }
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus" {
     return teeUpStatusArray[row]
     }
     else{
     return individualStatusArray[row]
     }
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
     {
     if isteeUpOrIndividualStatusChanged == "changeTeeUpStatus" {
     if(row == 0){
     teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
     teeUpStatusLabel.text = "Planning"
     }
     if(row == 1){
     teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
     teeUpStatusLabel.text = "It's On"
     }
     if(row == 2){
     teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
     teeUpStatusLabel.text = "Happening"
     }
     if(row == 3){
     teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
     teeUpStatusLabel.text = "It's Ended"
     }
     if(row == 4){
     teeUpStatusIcon.image = UIImage(named: "planning_sym.png")
     teeUpStatusLabel.text = "Canceled"
     }
     }
     else{
     if(row == 0){
     individualStatusIcon.image = UIImage(named: "going_sym.png")!
     individualStatusLabel.text = "Invited"
     }
     if(row == 1){
     individualStatusIcon.image = UIImage(named: "mightGo_sym.png")
     individualStatusLabel.text = "Might Go"
     }
     if(row == 2){
     individualStatusIcon.image = UIImage(named: "interested_sym.png")
     individualStatusLabel.text = "Interested"
     }
     if(row == 3){
     individualStatusIcon.image = UIImage(named: "notGoing_sym.png")
     individualStatusLabel.text = "Not Going"
     }
     if(row == 4){
     individualStatusIcon.image = UIImage(named: "interested.png")
     individualStatusLabel.text = "On My Way"
     }
     if(row == 5){
     individualStatusIcon.image = UIImage(named: "interested.png")
     individualStatusLabel.text = "Arrived"
     }
     }
     }
     */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
