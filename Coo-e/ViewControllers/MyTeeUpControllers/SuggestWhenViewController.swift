//
//  SuggestWhenViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 25/12/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class SuggestWhenViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateSelected: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "When Suggestions"
        datePicker.isHidden = true
        
        //navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func suggestWhenButtonClicked(_ sender: UIButton) {
        datePicker.isHidden = false
    }
    
    @IBAction func datePickerFunc(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
        let strDate = dateFormatter.string(from: datePicker.date)
        dateSelected.text = strDate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePicker.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
