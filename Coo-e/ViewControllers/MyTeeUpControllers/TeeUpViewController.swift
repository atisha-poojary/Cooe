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
    var lastTeeUpStatusSelected : String!
    var lastIndividualStatusSelected : String!
    var teeUpDictionary : NSDictionary!
    
    
    //@IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var teeUpStatusTable: UITableView!
    @IBOutlet weak var individualStatusTable: UITableView!
    
    @IBOutlet weak var selectedDate: UILabel!
    
    @IBOutlet weak var teeUpStatusIcon: UIImageView!
    @IBOutlet weak var teeUpStatusLabel: UILabel!
    @IBOutlet weak var individualStatusIcon: UIImageView!
    @IBOutlet weak var individualStatusLabel: UILabel!
    @IBOutlet weak var participantsScrollView: UIScrollView!
    
    @IBOutlet weak var when_like_countLabel:UILabel!
    @IBOutlet weak var when_dislike_countLabel:UILabel!
    @IBOutlet weak var where_like_countLabel:UILabel!
    @IBOutlet weak var where_dislike_countLabel:UILabel!
    
    var teeUpStatusArray = ["Planning","It's On","Happening","It's Ended","Cancelled"]
    var individualStatusArray = ["Invited","Might Go","Interested","Not Going","On My Way","Arrived"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerView.isHidden = true
        //datePicker.isHidden = true
        
        teeUpStatusTable.isHidden = true
        individualStatusTable.isHidden = true
        
        self.teeUpStatusTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.individualStatusTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
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
            
            //using local data
//            let url = Bundle.main.url(forResource: "data", withExtension: "json")
//            let data = NSData(contentsOf: url!)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    
                    print("dict:'\(dict)")
                    
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
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

                                    }
                                    else if status == 404{
                                        
                                    }
                                }
                            }
                            return
                        }
                        else {
                            let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    }
                }
            }catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }
    
    func addParticipantsToScrollView(_ numberOfParticipants: Int) {
        
        for i in 0..<numberOfParticipants {
            let participantView = UIView(frame: CGRect(x: i*80 + 10, y: 15, width: 70, height: 70))
            self.participantsScrollView.addSubview(participantView)
            
            let profilePicture = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            profilePicture.imageFromUrl(urlString: "http://scontent.cdninstagram.com/t51.2885-19/s150x150/15276748_1238248896241231_7045268600633950208_a.jpg")
            profilePicture.setRounded()
            
            let statusOfParticipantImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            
            let viewParticipantsDetailScreenButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            viewParticipantsDetailScreenButton.addTarget(self, action: #selector(showParticipantsDetailScreen), for: .touchUpInside)
            
            switch ((self.teeUpDictionary["participants"] as! NSArray).object(at: 0) as AnyObject).object(forKey: "status") as! Int {
            case 0:
                self.individualStatusLabel.text = "Invited"
                statusOfParticipantImageView.image = UIImage(named: "going.png")
            case 1:
                self.individualStatusLabel.text = "Might Go"
                statusOfParticipantImageView.image = UIImage(named: "invited.png")
            case 2:
                self.individualStatusLabel.text = "Interested"
                statusOfParticipantImageView.image = UIImage(named: "interested.png")
            case 3:
                self.individualStatusLabel.text = "Not Going"
                statusOfParticipantImageView.image = UIImage(named: "going.png")
            case 4:
                self.individualStatusLabel.text = "On My Way"
                statusOfParticipantImageView.image = UIImage(named: "on my way.png")
            case 4:
                self.individualStatusLabel.text = "Arrived"
                statusOfParticipantImageView.image = UIImage(named: "going.png")
                
            default:
                break
            }
            
            print("self.individualStatusLabel.text \(self.individualStatusLabel.text)")
            participantView.addSubview(profilePicture)
            participantView.addSubview(statusOfParticipantImageView)
            participantView.addSubview(viewParticipantsDetailScreenButton)
        }
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
        //pickerView.reloadAllComponents()
    }
    
    
//    @IBAction func suggestWhenButtonClicked(_ sender: UIButton) {
//        datePicker.isHidden = false
//    }
//    
//     @IBAction func datePickerFunc(_ sender: AnyObject) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//        let strDate = dateFormatter.string(from: datePicker.date)
//        selectedDate.text = strDate
//    }
    
    
    
    
    
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
        }
        else{
            if(indexPath.row == 0){
                individualStatusIcon.image = UIImage(named: "going_sym.png")!
                individualStatusLabel.text = "Invited"
            }
            if(indexPath.row == 1){
                individualStatusIcon.image = UIImage(named: "mightGo_sym.png")
                individualStatusLabel.text = "Might Go"
            }
            if(indexPath.row == 2){
                individualStatusIcon.image = UIImage(named: "interested_sym.png")
                individualStatusLabel.text = "Interested"
            }
            if(indexPath.row == 3){
                individualStatusIcon.image = UIImage(named: "notGoing_sym.png")
                individualStatusLabel.text = "Not Going"
            }
            if(indexPath.row == 4){
                individualStatusIcon.image = UIImage(named: "interested.png")
                individualStatusLabel.text = "On My Way"
            }
            if(indexPath.row == 5){
                individualStatusIcon.image = UIImage(named: "interested.png")
                individualStatusLabel.text = "Arrived"
            }
            individualStatusTable.isHidden = true
        }
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
        self.navigationItem.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
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
