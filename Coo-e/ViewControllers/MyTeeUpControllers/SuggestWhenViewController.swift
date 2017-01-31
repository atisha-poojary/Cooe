//
//  SuggestWhenViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 25/12/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SuggestWhenViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateSelected: UILabel!
    @IBOutlet weak var startDateAndTime_textField: UITextField!
    @IBOutlet weak var endDateAndTime_textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "When Suggestions"
        datePicker.isHidden = true
        
        //navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        startDateAndTime_textField.addTarget(self, action: #selector(updateLabel), for: .editingChanged)
        endDateAndTime_textField.addTarget(self, action: #selector(updateLabel), for: .editingChanged)
    }
    
    func updateLabel(whichTextFiled: Int) {
        let chrono = Chrono.shared
        let date = chrono.dateFrom(naturalLanguageString: inputField.text!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let discoveredDate = date else {
            //discoveredDateLabel.text = ""
            return
        }
        //discoveredDateLabel.text = dateFormatter.string(from: discoveredDate)
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
