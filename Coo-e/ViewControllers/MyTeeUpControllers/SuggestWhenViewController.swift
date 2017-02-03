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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var whenDateAndTime_textField: UITextField!
    var teeUp_id: String!
    var timestamp: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "When Suggestions"
        datePicker.isHidden = true
        
        //navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        whenDateAndTime_textField.addTarget(self, action: #selector(updateLabel), for: .editingChanged)
    }
    
    func updateLabel(whichTextFiled: Int) {
        let chrono = Chrono.shared
        let date = chrono.dateFrom(naturalLanguageString: whenDateAndTime_textField.text!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let discoveredDate = date else {
            dateLabel.text = ""
            timeLabel.text = ""
            return
        }
        var dateAndTimeArr = dateFormatter.string(from: discoveredDate).components(separatedBy: "at ")
        
        dateLabel.text = dateAndTimeArr[0]
        timeLabel.text = dateAndTimeArr[1]
        
        timestamp = String(discoveredDate.timeIntervalSince1970)
        print("timestamp\(timestamp)")
        
    }
    
    @IBAction func cancel_or_suggestButtonClicked(_ sender: UIButton) {
        let buttonTag = sender.tag
        if(buttonTag == 0){
            _ = navigationController?.popViewController(animated: true)
        }
        else if (buttonTag == 1){
            let url: NSURL = NSURL(string:"http://69.164.208.35:8080/api/when")!
            
            let params = ["teeupId":teeUp_id, "whenFrom":timestamp] as Dictionary<String, Any>
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    DispatchQueue.main.async(execute: {
                        ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
                    })
                    return
                }
                
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    if let dict = json as? NSDictionary {
                        
                        print("dict:'\(dict)")
                        
                        if(error != nil) {
                            print(error!.localizedDescription)
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: '\(jsonStr)'")
                        }
                        else {
                            if let dict = json as? NSDictionary {
                                if let status = dict["status"] as? Int {
                                    print("status: \(status)")
                                    DispatchQueue.main.async{
                                        if status == 201 {
                                            print("Successfully created suggestion!")
                                        }
                                        else if status == 400 {
                                            ModelController().showToastMessage(message: dict["message"] as! String, view: self.view, y_coordinate: self.view.frame.size.height-85)
                                        }
                                    }
                                }
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
    }
    
    @IBAction func datePickerFunc(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
        let strDate = dateFormatter.string(from: datePicker.date)
        dateLabel.text = strDate
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
