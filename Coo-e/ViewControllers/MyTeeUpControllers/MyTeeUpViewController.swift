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
        
        self.getMyTeeups()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func isTeeUpCategory(_ sender: UIButton) {
        let buttonTag = sender.tag
        if(buttonTag == 0){
            isCategory = "Invities"
            
            invitesUnderlined.isHidden=false
            coordinatingUnderlined.isHidden=true
            pastUnderlined.isHidden=true
            
            self.tableView.isHidden=true
            no_teeUp_message.isHidden = false
            no_teeUp_message.text = "You haven't been invited to anything yet, try creating a Tee-Up with your friends"
            
            /*
            if self.myTeeupArray.count == 0{
                no_teeUp_message.isHidden = false
                no_teeUp_message.text = "You haven't been invited to anything yet, try creating a Tee-Up with your friends"
            }
            else{
                no_teeUp_message.isHidden = true
                self.getMyTeeups()
                self.tableView.reloadData()
            }
 */
        }
        else if(buttonTag == 1){
            isCategory = "Coordinating"
            
            coordinatingUnderlined.isHidden=false
            invitesUnderlined.isHidden=true
            pastUnderlined.isHidden=true
            
            self.tableView.isHidden=true
            
            if self.myTeeupArray.count == 0{
                no_teeUp_message.isHidden = false
                no_teeUp_message.text = "You're not coordinating anything yet, try creating a Tee-Up with your friends"
            }
            else{
                no_teeUp_message.isHidden = true
                self.getMyTeeups()
                self.tableView.reloadData()
            }
 
        }
        else if(buttonTag == 2){
            isCategory = "Past"
            
            pastUnderlined.isHidden=false
            coordinatingUnderlined.isHidden=true
            invitesUnderlined.isHidden=true
            
            self.tableView.isHidden=true
            no_teeUp_message.isHidden = false
            no_teeUp_message.text = "You have not made plans with people yet, get started by creating a Tee-Up with your friends"
            
            /*
            if self.myTeeupArray.count == 0{
                no_teeUp_message.isHidden = false
                no_teeUp_message.text = "You have not made plans with people yet, get started by creating a Tee-Up with your friends"
            }
            else{
                no_teeUp_message.isHidden = true
                self.getMyTeeups()
                self.tableView.reloadData()
            }
 */
        }
    }
    
    func getMyTeeups()
    {
        let urlString = ("http://69.164.208.35:8080/api/teeups")
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
                                        self.myTeeupArray = (dict["teeups"] as? NSArray)!
                                        if self.myTeeupArray.count == 0 {
                                            self.tableView.isHidden = true
                                            self.no_teeUp_message.isHidden = false
                                            self.no_teeUp_message.text = "You're not coordinating anything yet, try creating a Tee-Up with your friends"
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
                        else {
                            let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    }
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
        
        if(isCategory == "Invities"){
            let cell:InvitedCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "InvitedCustomCell") as! InvitedCustomCell!)
            
            if self.myTeeupArray.count != 0 {
                cell.title.text = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
                cell.message.text = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "message") as? String
                
//                let createdByString = "Created by \((((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as AnyObject).object(forKey: "firstName") as? String)!) \(((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as AnyObject).object(forKey: "lastName") as? String)!)"
//                cell.createdByLabel.text = createdByString

            }
            return cell
        }
        else if(isCategory == "Coordinating"){
            let cell:CoordinatingCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "CoordinatingCustomCell") as! CoordinatingCustomCell!)
            if self.myTeeupArray.count != 0 {
                cell.title.text = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
                cell.message.text = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "message") as? String
                
                //change to the url you get from the response
                //cell.profilePicture.imageFromUrl(urlString: "http://scontent.cdninstagram.com/t51.2885-19/s150x150/15276748_1238248896241231_7045268600633950208_a.jpg")
                
                
                
//                let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)

                
                let imageData = NSData(base64Encoded: "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"
, options: .ignoreUnknownCharacters)
                let image = UIImage.init(data: imageData as! Data)
                cell.profilePicture.image = image
                
                let createdByString = "Created by \((((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as AnyObject).object(forKey: "firstName") as? String)!) \((((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as AnyObject).object(forKey: "lastName") as? String)!)"
                cell.createdByLabel.text = createdByString
                
                switch ((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "status") as? Int)! {
                case 0:
                    cell.teeupStatus.text = "Planning"
                case 1:
                    cell.teeupStatus.text = "It's On"
                case 2:
                    cell.teeupStatus.text = "Happening"
                case 3:
                    cell.teeupStatus.text = "It's Ended"
                case 4:
                    cell.teeupStatus.text = "Cancelled"
                    
                default:
                    break
                }

                if let gamePlanWhenDict = ((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "gamePlanWhen") as AnyObject) as? NSDictionary {
                    cell.whenLabel.text = "\(timeStringFromUnixTime ((gamePlanWhenDict.object(forKey: "fromDate") as? String)!)) -\n\(timeStringFromUnixTime ((gamePlanWhenDict.object(forKey: "toDate") as? String)!))"
                    cell.whenLabel.adjustsFontSizeToFitWidth = true
                }
                else {
                    cell.whenLabel.text = "No time set"
                }
            }
            return cell
        }
        else if(isCategory == "Past"){
            let cell:ArchiveCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "ArchiveCustomCell") as! ArchiveCustomCell!)
            if self.myTeeupArray.count != 0 {
                cell.title.text = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
                //cell.message.text = (self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "message") as? String
                //cell.createdByLabel.text = ((self.myTeeupArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as AnyObject).object(forKey: "firstName") as? String
            }
            return cell
        }
 
        return cell
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
    
    func timeStringFromUnixTime(_ unixTime: String) -> String {
        //let date = Date(timeIntervalSince1970:(unixTime)/1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.AAAZ"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        let myDate: Date = dateFormatter.date(from: unixTime)!

        //myDate = NSDate(timeIntervalSinceReferenceDate: -3_938_698_800.0) as Date
        dateFormatter.dateFormat = "MMM dd, YY h:mm"
        return dateFormatter.string(from: myDate)
    }
    
    func refresh(_ sender:AnyObject){
        if Reachability()?.modifiedReachabilityChanged() == true {
            self.getMyTeeups()
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
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


//0 is creator
//
//1 is organizer
//
//2 is just regular participant
