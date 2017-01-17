//
//  CreateTeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 04/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class CreateTeeUpViewController: UIViewController, UITextFieldDelegate, CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var title_textField: UITextField!
    @IBOutlet weak var message_textView: UITextView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var contact_textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [CNContact] = []
    var store = CNContactStore()
    var phoneNumberArray: [String] = []
    var emailArray:[String] = []

        override func viewDidLoad() {
        super.viewDidLoad()
        
            if self.revealViewController() != nil {
                menuButton.target = self.revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
            self.tableView!.isHidden=true
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Coo-e", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func textFieldValueChanged(sender: AnyObject) {
        if let query = contact_textField.text {
            self.tableView!.isHidden=false
            findContactsWithName(name: query)
        }
    }
    
    
    func findContactsWithName(name: String) {
        AppDelegate.sharedDelegate().checkAccessStatus(completionHandler: { (accessGranted) -> Void in
            print(accessGranted)
            if accessGranted {
                DispatchQueue.main.async{ () -> Void in
                    do {
                        self.contacts = []
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: "%\(name)%")
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
                        self.contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                        print("self.contacts \(self.contacts)")
                        self.tableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch the selected contact.")
                    }
                }
            }
        })
    }
    
    
    @IBAction func contactIconClicked(sender: AnyObject) {
//        let contactPickerViewController = CNContactPickerViewController()
//        contactPickerViewController.delegate = self
//        present(contactPickerViewController, animated: true, completion: nil)
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        do {
            self.contacts = []
            
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop) -> Void in
                self.contacts.append(contact)
            })
            
            DispatchQueue.main.async(execute: {
                print("self.contacts \(self.contacts)")
                self.tableView.isHidden=false
                self.tableView.reloadData()
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let contact = contacts[indexPath.row] as CNContact
        cell.textLabel!.text = "\(contact.givenName) \(contact.familyName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contacts[indexPath.row] as CNContact
        let phoneNumber = contacts[indexPath.row].phoneNumbers
        let email = contacts[indexPath.row].emailAddresses
        
        print(contact.givenName)
        print(phoneNumber[0].value.stringValue)
        
        if phoneNumber.count > 0 {
            if !phoneNumberArray.contains(phoneNumber[0].value.stringValue) {
                phoneNumberArray.append(phoneNumber[0].value.stringValue)
                print("phoneNumberArray \(phoneNumberArray)")
            }
        }
        
        if email.count > 0 {
            if !emailArray.contains(email[0].value as String) {
                emailArray.append(email[0].value as String)
                print("emailArray \(emailArray)")
            }

        }
    }
    
    @IBAction func sendInvitationClicked(sender: AnyObject){
    
        if title_textField.text! == "" && message_textView.text! == "" {
            ModelController().showToastMessage(message: "Enter a title for the Tee-Up", view: self.view, y_coordinate: self.view.frame.size.height-85)
        }
        else if title_textField.text! != "" || message_textView.text! == "" {
            
            let url: NSURL = NSURL(string:"http://69.164.208.35:8080/api/teeups")!
            
            let params = ["title":title_textField.text!, "message":message_textView.text!, "inviteEmails":emailArray, "invitePhones":phoneNumberArray] as Dictionary<String, Any>
            
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
                                        else if status == 500 {
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.isHidden=true
    }
    
    @IBAction func writeTitle(_ sender: AnyObject) {
        if Reachability()?.modifiedReachabilityChanged() == true {
        
        }
    }

    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as! CNPhoneNumber
        
        print(contact.givenName)
        print(phoneNumber.stringValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title_textField.becomeFirstResponder()
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
