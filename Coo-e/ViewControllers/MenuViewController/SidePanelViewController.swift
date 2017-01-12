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
    
    var menuListArray = ["TeeUps", "Discover", "Create My TeeUp", "Contacts", "Profile", "Setting", "Help", "Feedback", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change to the url you get from the response
        profilePicture.imageFromUrl(urlString: "http://scontent.cdninstagram.com/t51.2885-19/s150x150/15276748_1238248896241231_7045268600633950208_a.jpg")
        profilePicture.setRounded()
        userName.text = "\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)"
        emailAddress.text = (UserDefaults.standard.string(forKey: "email"))!
        
        // Do any additional setup after loading the view.
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


