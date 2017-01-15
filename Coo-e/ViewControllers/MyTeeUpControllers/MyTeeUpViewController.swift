//
//  MyTeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 17/10/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit
import Firebase
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
              ModelController().showToastMessage(message: "No internet connection.", view: self.view)
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
                cell.profilePicture.imageFromUrl(urlString: "http://scontent.cdninstagram.com/t51.2885-19/s150x150/15276748_1238248896241231_7045268600633950208_a.jpg")
                
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
            ModelController().showToastMessage(message: "No internet connection.", view: self.view)
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
