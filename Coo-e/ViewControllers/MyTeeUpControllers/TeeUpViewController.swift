//
//  TeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 03/12/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class TeeUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
 {
    var teeUp_id : String!
    var isteeUpOrIndividualStatusChanged = "changeTeeUpStatus"
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var teeUpStatusIcon: UIImageView!
    @IBOutlet weak var teeUpStatusLabel: UILabel!
    @IBOutlet weak var individualStatusIcon: UIImageView!
    @IBOutlet weak var individualStatusLabel: UILabel!
    
    var teeUpStatusArray = ["Planning","It's On","Happening","It's Ended","Canceled"]
    var individualStatusArray = ["Invited","Might Go","Interested","Not Going","On My Way","Arrived"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("teeUp_id\(teeUp_id)")
        pickerView.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.parent?.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func statusButtonClicked(_ sender: UIButton) {
        pickerView.isHidden = false

        let buttonTag = sender.tag
        if buttonTag == 0{
            isteeUpOrIndividualStatusChanged = "changeTeeUpStatus"
        }
        else {
            isteeUpOrIndividualStatusChanged = "changeIndividualStatus"
        }
        pickerView.reloadAllComponents()
    }
    
    //picker view
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
                teeUpStatusIcon.image = UIImage(named: "planning.png")
                teeUpStatusLabel.text = "Planning"
            }
            if(row == 1){
                teeUpStatusIcon.image = UIImage(named: "planning.png")
                teeUpStatusLabel.text = "It's On"
            }
            if(row == 2){
                teeUpStatusIcon.image = UIImage(named: "planning.png")
                teeUpStatusLabel.text = "Happening"
            }
            if(row == 3){
                teeUpStatusIcon.image = UIImage(named: "planning.png")
                teeUpStatusLabel.text = "It's Ended"
            }
            if(row == 4){
                teeUpStatusIcon.image = UIImage(named: "planning.png")
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
    
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: false)
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
