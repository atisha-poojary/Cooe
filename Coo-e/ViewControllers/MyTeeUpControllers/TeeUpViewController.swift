//
//  TeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 03/12/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class TeeUpViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

    var teeUp_id : Int!
    var teeUp_title : String!
    @IBOutlet weak var teeUpTitleLabel:UILabel!
    
    var isteeUpOrIndividualStatusChanged = "changeTeeUpStatus"
    var lastTeeUpStatusSelected : String!
    var lastIndividualStatusSelected : String!
    
    
    //@IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var teeUpStatusTable: UITableView!
    @IBOutlet weak var individualStatusTable: UITableView!
    
    @IBOutlet weak var selectedDate: UILabel!
    
    @IBOutlet weak var teeUpStatusIcon: UIImageView!
    @IBOutlet weak var teeUpStatusLabel: UILabel!
    @IBOutlet weak var individualStatusIcon: UIImageView!
    @IBOutlet weak var individualStatusLabel: UILabel!
    @IBOutlet weak var peopleScrollView: UIScrollView!
    
    @IBOutlet weak var when_like_countLabel:UILabel!
    @IBOutlet weak var when_dislike_countLabel:UILabel!
    @IBOutlet weak var where_like_countLabel:UILabel!
    @IBOutlet weak var where_dislike_countLabel:UILabel!
    
    var teeUpStatusArray = ["Planning","It's On","Happening","It's Ended","Canceled"]
    var individualStatusArray = ["Invited","Might Go","Interested","Not Going","On My Way","Arrived"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("teeUp_id\(self.teeUp_id!)")
        teeUpTitleLabel.text = teeUp_title
        //pickerView.isHidden = true
        //datePicker.isHidden = true
        
        teeUpStatusTable.isHidden = true
        individualStatusTable.isHidden = true
        
        self.teeUpStatusTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.individualStatusTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
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
    
    
    
    func addPeopleToScrollView() {
    
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
