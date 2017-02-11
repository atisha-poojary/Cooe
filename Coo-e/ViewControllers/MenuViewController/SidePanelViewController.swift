//
//  SidePanelViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 19/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var cache: NSCache<AnyObject, AnyObject>!
    
    var menuListArray = ["TeeUps", "Discover", "Create My TeeUp", "Contacts", "Profile", "Setting", "Help", "Feedback", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change to the url you get from the response
        //profilePicture.imageFromUrl(urlString: "http://resources.coo-e.com:3000/api/image/\((UserDefaults.standard.string(forKey: "imageId")))")
       
        profilePicture.setRounded()
        userName.text = "\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)"
        emailAddress.text = (UserDefaults.standard.string(forKey: "email"))!
        self.cache = NSCache()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
//        if ((NSCache<AnyObject, AnyObject>().object(forKey:"profilePicture" as AnyObject)) != nil){
//            self.profilePicture.image = self.cache.object(forKey:"profilePicture" as AnyObject) as? UIImage
//        }        
        if (UserDefaults.standard.string(forKey: "imageId") != nil){
            self.getProfilPic()
        }
    }
    
    func getProfilPic()
    {
        let urlString = ("http://69.164.208.35:8080/api/image/\((UserDefaults.standard.string(forKey: "imageId"))!)")
        print("urlString\(urlString)")
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
                                    if status == 200{
                                        let strBase64 = ((dict["image"] as AnyObject).object(forKey: "imageData") as! String)
                                        print("strBase64\(strBase64)")
                                        let imageData = NSData(base64Encoded: strBase64, options: .ignoreUnknownCharacters)
                                        self.profilePicture.image = UIImage.init(data: imageData as! Data)
                                    }
                                    else {
                                         ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
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

    
    // Mark: Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: self.menuListArray[indexPath.row])! as UITableViewCell
        
        return cell
    }
    
    @IBAction func showAlert(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Logout", style: .default , handler:{ (UIAlertAction)in
            for cookie in HTTPCookieStorage.shared.cookies! {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            
            let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            
            
        }))
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // the contact framework will return me
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


