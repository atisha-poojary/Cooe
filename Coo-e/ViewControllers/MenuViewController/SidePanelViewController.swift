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

        
//        profilePicture.imageFromUrl(urlString: "https://www.google.com/search?q=atisha+poojary+avatar&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjP0fK2oKPRAhVHeSYKHX6vCE0Q_AUICCgB&biw=1106&bih=566#tbm=isch&q=atisha+poojary&imgrc=y9AicfGWT4VWsM%3A")
//        profilePicture.setRounded()
//        userName.text = "\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!)"
//        emailAddress.text = (UserDefaults.standard.string(forKey: "emailAddress"))!
//        tableView.reloadData()
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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


