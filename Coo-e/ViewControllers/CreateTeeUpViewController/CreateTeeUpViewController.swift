//
//  CreateTeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 04/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit
import Contacts

class CreateTeeUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var title_textField: UITextField!
    @IBOutlet weak var message_textView: UITextView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var store = CNContactStore()
    var contacts: [CNContact] = []

        override func viewDidLoad() {
        super.viewDidLoad()
        
            if self.revealViewController() != nil {
                menuButton.target = self.revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
            AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
                print(accessGranted)
            })
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
            
            let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: "Atisha Poojary")
            self.contacts = try! self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as [CNKeyDescriptor])
            
    }
    
    func findContactsWithName(name: String) {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            if accessGranted {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                })
            }
        })
    }
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Coo-e", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title_textField.becomeFirstResponder()
    }
    
    @IBAction func sendInvitationClicked(sender: AnyObject){
    
        if title_textField.text! == "" && message_textView.text! == "" {
            ModelController().showToastMessage(message: "Enter a title for the Tee-Up", view: self.view)
        }
        else if title_textField.text! != "" || message_textView.text! == "" {
            
            let url: NSURL = NSURL(string:"http://69.164.208.35:8080/api/teeups")!
            
            let params = ["title":title_textField.text!, "message":message_textView.text!] as Dictionary<String, String>
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            //let configuration = URLSessionConfiguration.default
            //configuration.httpCookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
            //let session = URLSession(configuration: configuration)
            
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
                
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
                print("Body: \(strData)")
                    
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                    if let dict = json as? NSDictionary {
                        
                        print("dict:'\(dict)")
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        if(error != nil) {
                            print(error!.localizedDescription)
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: '\(jsonStr)'")
                        }
                        else {
                            
                            // The JSONObjectWithData constructor didn't return an error. But, we should still
                            // check and make sure that json has a value using optional binding.
                            if let dict = json as? NSDictionary {
                                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                                if let status = dict["status"] as? Int {
                                    print("status: \(status)")
                                    DispatchQueue.main.async{
                                        if status == 201 {
                                            
                                          print("Teeup created successfully")
                                            
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func writeTitle(_ sender: AnyObject) {
        if Reachability()?.modifiedReachabilityChanged() == true {
        
        }
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
