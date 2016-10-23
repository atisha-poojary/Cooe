//
//  SignUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 14/10/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

   
    @IBOutlet weak var username_textField: UITextField!
    @IBOutlet weak var firstName_textField: UITextField!
    @IBOutlet weak var lastName_textField: UITextField!
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var mobilePhone_textField: UITextField!
    @IBOutlet weak var password_textField: UITextField!
    @IBOutlet weak var retypePassword_textField: UITextField!

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var username_errorLabel: UILabel!
    @IBOutlet weak var firstName_errorLabel: UILabel!
    @IBOutlet weak var lastName_errorLabel: UILabel!
    @IBOutlet weak var email_errorLabel: UILabel!
    @IBOutlet weak var mobilePhone_errorLabel: UILabel!
    @IBOutlet weak var password_errorLabel: UILabel!
    @IBOutlet weak var retypePassword_errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageLabel.isHidden = true
        
        self.username_errorLabel.isHidden = true
        self.firstName_errorLabel.isHidden = true
        self.lastName_errorLabel.isHidden = true
        self.email_errorLabel.isHidden = true
        self.mobilePhone_errorLabel.isHidden = true
        self.password_errorLabel.isHidden = true
        self.retypePassword_errorLabel.isHidden = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        
        let username = username_textField.text!
        let firstName = firstName_textField.text!
        let lastName = lastName_textField.text!
        let email = email_textField.text!
        let mobilePhone = mobilePhone_textField.text!
        let password = password_textField.text!
        let retypePassword = retypePassword_textField.text!
        
        if username == "" && firstName == "" && lastName == "" && email == "" && mobilePhone == "" && password == "" && retypePassword == ""{
            self.messageLabel.isHidden = false
            
            self.username_errorLabel.isHidden = false
            self.firstName_errorLabel.isHidden = false
            self.lastName_errorLabel.isHidden = false
            self.email_errorLabel.isHidden = false
            self.mobilePhone_errorLabel.isHidden = false
            self.password_errorLabel.isHidden = false
            self.retypePassword_errorLabel.isHidden = false
            
            
            let avatarId = "5"
            let profilePic = ""
            self.signUpFunc(username: username, email: email, avatarId: avatarId, password: password, firstName: firstName, lastName: lastName, profilePic: profilePic)
            
            /*
             let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 130, self.view.frame.size.height-80, 260, 24))
             toastLabel.backgroundColor = UIColor.blackColor()
             toastLabel.textColor = UIColor.whiteColor()
             toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
             toastLabel.textAlignment = NSTextAlignment.Center;
             self.view.addSubview(toastLabel)
             toastLabel.text = "You have been successfully registered."
             toastLabel.alpha = 1.0
             toastLabel.layer.cornerRadius = 5;
             toastLabel.clipsToBounds  =  true
             
             UIView.animateWithDuration(4.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations:{
             
             toastLabel.alpha = 0.0
             
             }, completion: {(completed) in
             
             let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
             let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
             appDelegate.window?.rootViewController = viewController
             self.navigationController?.popToRootViewControllerAnimated(true)
             })
             */
            //return
        }
            
        else if username == "" || firstName == "" || lastName == "" && email == "" || mobilePhone == "" || password == "" || retypePassword == ""{
            
            if !isValidEmail(email: email){
               
            }
            
            if username == ""{
                self.username_errorLabel.isHidden = false
            }
            
            if password == ""{
                self.password_errorLabel.isHidden = false
            }
            else{
                self.password_errorLabel.isHidden = true
            }
            
            if retypePassword == ""{
                self.retypePassword_errorLabel.isHidden = false
            }
            else{
                self.retypePassword_errorLabel.isHidden = true
            }
            
            if mobilePhone == "" {
                self.mobilePhone_errorLabel.isHidden = false
            }
            
            if password != retypePassword{
                if password != "" && retypePassword == ""{
                    self.retypePassword_errorLabel.isHidden = false
                }
                else if password == "" && retypePassword != ""{
                    self.password_errorLabel.isHidden = false
                }
                else{
                    self.password_errorLabel.isHidden = true
                    self.retypePassword_errorLabel.isHidden = false
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = "Password does not match"
                }
            }
            else {
                if password == "" && retypePassword == "" {
                    self.password_errorLabel.isHidden = false
                    self.retypePassword_errorLabel.isHidden = false
                }
                else{
                    self.password_errorLabel.isHidden = true
                    self.retypePassword_errorLabel.isHidden = true
                }
            }
        }
        else if username != "" && firstName != "" && lastName != "" && email != "" && mobilePhone != "" && password != "" && retypePassword != "" {
            if password != retypePassword{
                if password != "" && retypePassword == ""{
                    self.retypePassword_errorLabel.isHidden = false
                }
                else if password == "" && retypePassword != ""{
                    self.password_errorLabel.isHidden = false
                  }
                else{
                    self.password_errorLabel.isHidden = true
                    self.retypePassword_errorLabel.isHidden = false
                }
            }
            else{
                let avatarId = "5"
                let profilePic = ""
                self.signUpFunc(username: username, email: email, avatarId: avatarId, password: password, firstName: firstName, lastName: lastName, profilePic: profilePic)
            }
        }
    }

    func signUpFunc(username: String, email: String, avatarId: String, password: String, firstName: String, lastName: String, profilePic: String)
    {
        
        let urlString = "http://resources.coo-e.com:8080/cooe/profile/"
        
        //let params = ["userName":"hiralp009", "password":"84317672"] as Dictionary<String, String>
        
        let username = "atisha-poojary"
        let email = "atishyam@gmail.com"
        let avatarId = "5"
        let password = "atisha19"
        let firstName = "Atisha"
        let lastName = "Poojary"
        let profilePic = ""
        
        let params = ["userName":username, "email":email, "avatarId":  avatarId, "password":password, "firstName":firstName, "lastName":lastName, "profilePic":profilePic] as Dictionary<String, String>
        
        let url: NSURL = NSURL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        //let params = "userName=hiralp009&password=84317672"
        //request.httpBody = params.data(using: String.Encoding.utf8)
        
        print("params=\(params)")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                DispatchQueue.main.async{
                    //self.feedsTableView.hidden = true
                    
                    let toastLabel = UILabel(frame: CGRect(origin: CGPoint(x:self.view.frame.size.width/2 - 90,y :self.view.frame.size.height-80), size: CGSize(width: 90+90, height: 24)))
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
                }
                return
            }
            
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Body: \(strData)")
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    // ... process the data
                    print(dict)
                    //var msg = "No message"
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                        //postCompleted(succeeded: false, msg: "Error")
                    }
                    else {
                        
                        // The JSONObjectWithData constructor didn't return an error. But, we should still
                        // check and make sure that json has a value using optional binding.
                        if let dict = json as? NSDictionary {
                            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                            if let code = dict["code"] as? String {
                                print("code: \(code)")
                                
                                DispatchQueue.main.async{
                                    if code == "COOE_005" {
                                        
                                        DispatchQueue.main.async{
                                            let toastLabel = UILabel(frame: CGRect(origin: CGPoint(x:self.view.frame.size.width/2 - 90,y :self.view.frame.size.height-80), size: CGSize(width: 90+90, height: 24)))
                                            toastLabel.backgroundColor = UIColor.black
                                            toastLabel.textColor = UIColor.white
                                            toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
                                            toastLabel.textAlignment = NSTextAlignment.center;
                                            toastLabel.text = "Username isn't valid"
                                            toastLabel.alpha = 1.0
                                            toastLabel.layer.cornerRadius = 4;
                                            toastLabel.layer.borderColor = UIColor.white.cgColor
                                            toastLabel.layer.borderWidth = CGFloat(Float (2.0))
                                            toastLabel.clipsToBounds = true
                                            
                                            self.view.addSubview(toastLabel)
                                            
                                            UIView.animate(withDuration: 2.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                                                toastLabel.alpha = 0.0
                                                }, completion: nil)
                                        }
                                        
                                        /*
                                        
                                        let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 140, self.view.frame.size.height-80, 285, 24))
                                        toastLabel.backgroundColor = UIColor.blackColor()
                                        toastLabel.textColor = UIColor.whiteColor()
                                        toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
                                        toastLabel.textAlignment = NSTextAlignment.Center;
                                        self.view.addSubview(toastLabel)

                                        toastLabel.text = "You have been successfully registered."
                                        toastLabel.alpha = 1.0
                                        toastLabel.layer.cornerRadius = 5;
                                        toastLabel.clipsToBounds  =  true
                                        
                                        UIView.animateWithDuration(4.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations:{
                                            
                                            toastLabel.alpha = 0.0
                                            
                                            }, completion: {(completed) in
                                                
                                                let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
                                                UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                                                self.navigationController?.popToRootViewControllerAnimated(true)
                                        })*/
                                    }
                                        /*
                                    else if response_code == 2 {
                                        self.email_errorLabel.hidden = false
                                        self.email_errorLabel.text = "This email is in use"
                                        
                                        self.emailTextField.layer.borderColor = UIColor.redColor().CGColor
                                        self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 3 {
                                        self.email_errorLabel.hidden = false
                                        self.email_errorLabel.text = "Email not valid. Please use NJIT email."
                                        
                                        self.emailTextField.layer.borderColor = UIColor.redColor().CGColor
                                        self.emailTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 4 {
                                        self.password_errorLabel.hidden = false
                                        self.password_errorLabel.text = "Password must be atleast 8 chararters long"
                                        
                                        self.passwordTextField.layer.borderColor = UIColor.redColor().CGColor
                                        self.passwordTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 8 {
                                        self.self.verificationCode_errorLabel.hidden = false
                                        self.self.verificationCode_errorLabel.text = "Verification code does not match"
                                        
                                        self.self.verificationCodeTextField.layer.borderColor = UIColor.redColor().CGColor
                                        self.self.verificationCodeTextField.layer.borderWidth = CGFloat(Float (1.0))
                                    }
                                    else if response_code == 9 {
                                        //Verification code has expired.
                                        let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 115, self.view.frame.size.height-320, 230, 24))
                                        toastLabel.backgroundColor = UIColor.blackColor()
                                        toastLabel.textColor = UIColor.whiteColor()
                                        toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 15)
                                        toastLabel.textAlignment = NSTextAlignment.Center;
                                        self.view.addSubview(toastLabel)
                                        //change
                                        toastLabel.text = "Verification code has expired."
                                        toastLabel.alpha = 1.0
                                        toastLabel.layer.cornerRadius = 5;
                                        toastLabel.clipsToBounds  =  true
                                        
                                        UIView.animateWithDuration(4.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations:{
                                            
                                            toastLabel.alpha = 0.0
                                            
                                            }, completion: nil)
                                    }*/
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
    
    func isValidEmail(email:String) -> Bool {
        //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@njit+\\.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonClicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)

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
