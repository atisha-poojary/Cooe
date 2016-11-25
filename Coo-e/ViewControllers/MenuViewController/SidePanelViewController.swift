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
    @IBOutlet weak var tableView: UITableView!
    
    var menuListArray: [String] = ["TeeUps", "Discover", "Create My TeeUp", "Contacts", "Profile", "Setting", "Help", "Feedback", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePicture.imageFromUrl(urlString: (UserDefaults.standard.string(forKey: "profileUrl"))!)
        userName.text = "\(UserDefaults.standard.string(forKey: "firstName")!) \(UserDefaults.standard.string(forKey: "lastName")!) "
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    // Mark: Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SidePanelCell = (self.tableView?.dequeueReusableCell(withIdentifier: "SidePanelCell") as! SidePanelCell!)
                
        cell.menuLabel.text = self.menuListArray[indexPath.row]
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.MenuCustomCell, for: indexPath) as! MenuCustomCell
        //cell.configureForAnimal(animals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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


extension UIImageView {
    public func imageFromUrl(urlString: String) {
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync() {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    public func setRounded() {
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

