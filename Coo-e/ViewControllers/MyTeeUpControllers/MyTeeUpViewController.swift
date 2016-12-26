//
//  MyTeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 17/10/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class MyTeeUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var invitesUnderlined:UILabel!
    @IBOutlet weak var coordinatingUnderlined:UILabel!
    @IBOutlet weak var pastUnderlined:UILabel!
    @IBOutlet weak var tableView: UITableView!
    var array: NSArray = []
    var isCategory : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.reloadTableView("191501201624240508")
        invitesUnderlined.isHidden=false
        coordinatingUnderlined.isHidden=true
        pastUnderlined.isHidden=true
        isCategory = "Invities"
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
            self.tableView.reloadData()
        }
        else if(buttonTag == 1){
            isCategory = "Coordinating"
            
            coordinatingUnderlined.isHidden=false
            invitesUnderlined.isHidden=true
            pastUnderlined.isHidden=true
            self.tableView.reloadData()
        }
        else if(buttonTag == 2){
            isCategory = "Past"
            
            pastUnderlined.isHidden=false
            coordinatingUnderlined.isHidden=true
            invitesUnderlined.isHidden=true
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView(_ profile_id: String)
    {
        let urlString = ("http://resources.coo-e.com:8080/cooe/profile/\(profile_id)/teeup/")
        let url: URL = URL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        _ = URLSession.shared
    
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    
                    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 90, y: self.view.frame.size.height-320, width: 90+90, height: 24))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
                    toastLabel.textAlignment = NSTextAlignment.center;
                    toastLabel.text = "No internet connection."
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 4;
                    toastLabel.layer.borderColor = UIColor.white.cgColor
                    toastLabel.layer.borderWidth = CGFloat(Float (2.0))
                    toastLabel.clipsToBounds = true
                    
                    self.view.addSubview(toastLabel)
                    
                    UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                        
                        toastLabel.alpha = 0.0
                        
                    }, completion: nil)
                })
                return
            }
            
            //print("Response: \(response)")
            //let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            //print("Body: \(strData)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                if let array = json as? NSArray {
                    // ... process the data
                    print(array)
                    //var msg = "No message"
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                        //postCompleted(succeeded: false, msg: "Error")
                    }
                    else {
                        
                        // The JSONObjectWithData constructor didn't return an error. But, we should still
                        // check and make sure that json has a value using optional binding.
                        if let array = json as? NSArray {
                            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                            self.array = array
                            print("self.array '\(self.array.count)'")
                             DispatchQueue.main.async(execute: {
                                
                            //self.tableView.estimatedRowHeight = 130;
                            //self.tableView.rowHeight = UITableViewAutomaticDimension;
                            self.tableView.reloadData()
                             })
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
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
//        if(segmentedControl.selectedSegmentIndex == 0){
//            if self.array.count != 0{
//                return self.array.count
//            }
//        }
//        else if(segmentedControl.selectedSegmentIndex == 1){
//            if self.array.count != 0{
//                return self.array.count
//            }
//        }
//        else if(segmentedControl.selectedSegmentIndex == 2){
//            if self.array.count != 0{
//                return self.array.count
//            }
//        }
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:InvitedCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "InvitedCustomCell") as! InvitedCustomCell!)
            
        if(isCategory == "Invities"){
            let cell:InvitedCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "InvitedCustomCell") as! InvitedCustomCell!)
            
            if self.array.count != 0 {
                cell.profilePicture.imageFromUrl(urlString: "http://\((((self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as? NSDictionary)?.object(forKey: "profile_picture_url") as? String)!)")
                
                cell.title.text = (self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
                cell.message.text = (self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "message") as? String
            }
            return cell
        }
        else if(isCategory == "Coordinating"){
            let cell:CoordinatingCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "CoordinatingCustomCell") as! CoordinatingCustomCell!)
            if self.array.count != 0 {
                cell.profilePicture.imageFromUrl(urlString: "http://\((((self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as? NSDictionary)?.object(forKey: "profile_picture_url") as? String)!)")
                
                cell.title.text = (self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
            }
            
            return cell
        }
        else if(isCategory == "Past"){
            let cell:ArchiveCustomCell = (self.tableView?.dequeueReusableCell(withIdentifier: "ArchiveCustomCell") as! ArchiveCustomCell!)
            if self.array.count != 0 {
                cell.profilePicture.imageFromUrl(urlString: "http://\((((self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "creator") as? NSDictionary)?.object(forKey: "profile_picture_url") as? String)!)")
                
                cell.title.text = (self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeeUpViewController") as! TeeUpViewController
    
        vc.teeUp_id = (self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "teeup_id")! as! Int
        vc.teeUp_title = ((self.array.object(at: (indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title") as? String)!
        
        vc.hidesBottomBarWhenPushed = true
        //self.parent?.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = ""
        self.navigationController?.show(vc, sender: nil)
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


