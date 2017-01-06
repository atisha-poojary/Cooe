//
//  LoginViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 14/10/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to logout.
     @param loginButton The button that was clicked.
     */
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }

    let FBLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()

    @IBOutlet weak var username_textField: UITextField!
    @IBOutlet weak var password_textField: UITextField!
    
    @IBAction func signInClicked(sender: AnyObject){
        
//        let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sw_rear")
//        UIApplication.shared.keyWindow?.rootViewController = viewController
//        _ = self.navigationController?.popToRootViewController(animated: true)
//        
//        return
        
        if Reachability()?.modifiedReachabilityChanged() == true{
            self.signInFunc()
        }
        else{
            DispatchQueue.main.async{
                //self.feedsTableView.hidden = true
                
                let toastLabel = UILabel(frame: CGRect(origin: CGPoint(x:self.view.frame.size.width/2 - 90,y :self.view.frame.size.height-80), size: CGSize(width: 90+90, height: 24)))
                    //UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 90, self.view.frame.size.height-80, 90+90, 24))
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
                
                
                self.signInFunc()
            }
        }
    }
    
    func signInFunc() {
        
        let username = username_textField.text!
        let password = password_textField.text!
        
        if username == "" && password == "" {
            
            //            self.newsfeedTabbarController = UIStoryboard.centerViewController()
            //            self.newsfeedNavigationController = UINavigationController(rootViewController: self.newsfeedTabbarController)
            //            self.view.addSubview(self.newsfeedNavigationController.view)
            //            self.addChildViewController(self.newsfeedNavigationController)
            //
            //            UIApplication.sharedApplication().keyWindow?.rootViewController = self.newsfeedTabbarController;

            self.username_textField.resignFirstResponder()
            
            DispatchQueue.main.async {
                
                let message = "Please enter username and password."
                let stringWidth = message.widthOfString(usingFont: UIFont.systemFont(ofSize: 14.5)) + 16
                
                let toastLabel = UILabel(frame: CGRect(origin: CGPoint(x:self.view.frame.size.width/2 - ((stringWidth+5)/2),y :self.view.frame.size.height-85), size: CGSize(width: stringWidth+5, height: 24)))
                toastLabel.backgroundColor = UIColor.black
                toastLabel.textColor = UIColor.white
                toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
                toastLabel.textAlignment = NSTextAlignment.center;
                toastLabel.text = message
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 4;
                toastLabel.layer.borderColor = UIColor.white.cgColor
                toastLabel.layer.borderWidth = CGFloat(Float (1.0))
                toastLabel.clipsToBounds = true
                
                self.view.addSubview(toastLabel)
                
                UIView.animate(withDuration: 3.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                    
                    toastLabel.alpha = 0.0
                    
                    }, completion: nil)
            }
        }
        else if username == "" || password == "" {
            if username == "" {
                self.username_textField.becomeFirstResponder()
            }
            if password == "" {
                self.password_textField.becomeFirstResponder()
            }
        }
        else if username != "" && password != "" {
            
            let url: NSURL = NSURL(string:"http://69.164.208.35:8080/auth/login")!
            
            let params = ["username":"atisha", "password":"19atisha"] as Dictionary<String, String>

            let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                
                if let httpResponse = response as? HTTPURLResponse, let _ = httpResponse.allHeaderFields as? [String : String] {
    
                    if(httpResponse.statusCode == 200) {
                        self.setCookies(response: response!)
                        
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
                                                if status == 200 {
                                                    UserDefaults.standard.set(((dict["user"] as AnyObject).object(forKey: "firstName")!), forKey:"firstName")
                                                    UserDefaults.standard.set(((dict["user"] as AnyObject).object(forKey: "lastName")!), forKey:"lastName")
                                                    UserDefaults.standard.set(((dict["user"] as AnyObject).object(forKey: "email")!), forKey:"email")
                                                    UserDefaults.standard.set(((dict["user"] as AnyObject).object(forKey: "id")!), forKey:"id")
                                                    
                                                    let viewController: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sw_rear")
                                                    UIApplication.shared.keyWindow?.rootViewController = viewController
                                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                                    
                                                }
                                                else if status == 2 {
                                                    let message = "Invalid credential"
                                                    let stringWidth = message.widthOfString(usingFont: UIFont.systemFont(ofSize: 14.5)) + 16
                                                    
                                                    let toastLabel = UILabel(frame: CGRect(origin: CGPoint(x:self.view.frame.size.width/2 - ((stringWidth+5)/2),y :self.view.frame.size.height-85), size: CGSize(width: stringWidth+5, height: 24)))
                                                    toastLabel.backgroundColor = UIColor.black
                                                    toastLabel.textColor = UIColor.white
                                                    toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
                                                    toastLabel.textAlignment = NSTextAlignment.center;
                                                    toastLabel.text = message
                                                    toastLabel.alpha = 1.0
                                                    toastLabel.layer.cornerRadius = 4;
                                                    toastLabel.layer.borderColor = UIColor.white.cgColor
                                                    toastLabel.layer.borderWidth = CGFloat(Float (1.0))
                                                    toastLabel.clipsToBounds = true
                                                    
                                                    self.view.addSubview(toastLabel)
                                                    
                                                    UIView.animate(withDuration: 3.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                                                        
                                                        toastLabel.alpha = 0.0
                                                        
                                                    }, completion: nil)
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
                }
                
                /*
                if error != nil {
                    print("error=\(error)")
                    DispatchQueue.main.async {
                        
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
                }*/
                
               
                
                
            })
        
            task.resume()
        }
    }
    
    func setCookies(response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse {

            let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String : String], for: response.url!)
           
            let archivedObject = NSKeyedArchiver.archivedData(withRootObject: cookies as NSArray)
            let userDefaults = UserDefaults.standard
            UserDefaults.standard.set(archivedObject, forKey:"cookies")
            userDefaults.synchronize()
            
            for cookie in cookies {
                var cookieProperties = [HTTPCookiePropertyKey:Any]()
                cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
                cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
                cookieProperties[HTTPCookiePropertyKey.path] = cookie.path
                cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain
                cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
                cookieProperties[HTTPCookiePropertyKey.expires] = Date().addingTimeInterval(31536000)
                HTTPCookieStorage.shared.setCookie(HTTPCookie(properties: cookieProperties)!)
                
                print("name: \(cookie.name) value: \(cookie.value)")
            }
            
        }
    }
    
//    func isValidusername(username:String) -> Bool {
//        let usernameRegEx = "[A-Z0-9a-z._%+-]+@njit+\\.edu"
//        let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
//        return usernameTest.evaluateWithObject(username)
//    }
//    
//    @IBAction func username_textFieldEditingChanged(sender: AnyObject) {
//        if !isValidusername(username_textField.text!){
//            username_textField.layer.borderColor = UIColor.redColor().CGColor
//            username_textField.layer.borderWidth = CGFloat(Float (1.0))
//            
//            username_errorLabel.hidden = false
//            username_errorLabel.text = "Please enter a NJIT username"
//        }
//        else{
//            username_errorLabel.hidden = true
//            username_textField.layer.borderColor = UIColor.clearColor().CGColor
//        }
//    }
//    
//    @IBAction func password_textFieldEditingChanged(sender: AnyObject) {
//        password_errorLabel.hidden = true
//        password_textField.layer.borderColor = UIColor.clearColor().CGColor
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool
//    {
//        if textField == self.username_textField{
//            self.username_textField.resignFirstResponder()
//            self.password_textField.becomeFirstResponder()
//        }
//        if textField == self.password_textField{
//            self.password_textField.resignFirstResponder()
//            if Reachability.isConnectedToNetwork() == true {
//                self.signInFunc()
//            } else {
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 90, self.view.frame.size.height-320, 90+90, 24))
//                    toastLabel.backgroundColor = UIColor.blackColor()
//                    toastLabel.textColor = UIColor.whiteColor()
//                    toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 14.5)
//                    toastLabel.textAlignment = NSTextAlignment.Center;
//                    toastLabel.text = "No internet connection."
//                    toastLabel.alpha = 1.0
//                    toastLabel.layer.cornerRadius = 4;
//                    toastLabel.layer.borderColor = UIColor.whiteColor().CGColor
//                    toastLabel.layer.borderWidth = CGFloat(Float (2.0))
//                    toastLabel.clipsToBounds = true
//                    
//                    self.view.addSubview(toastLabel)
//                    
//                    UIView.animateWithDuration(2.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:{
//                        
//                        toastLabel.alpha = 0.0
//                        
//                        }, completion: nil)
//                })
//            }
//        }
//        return true
//    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil) {
            print("User logged in...")
        } else {
            print("User not logged in...")
        }
        
        FBLoginButton.center = view.center
        FBLoginButton.delegate = self
        //view.addSubview(FBLoginButton)
        
        // Do any additional setup after loading the view.
        /*
         let username_textFieldborder = CALayer()
         let username_textFieldwidth = CGFloat(1.0)
         username_textFieldborder.borderColor = UIColor.darkGrayColor().CGColor
         username_textFieldborder.frame = CGRect(x: 0, y: username_textField.frame.size.height - username_textFieldwidth, width:  username_textField.frame.size.width + 50, height: username_textField.frame.size.height)
         
         username_textFieldborder.borderWidth = username_textFieldwidth
         username_textField.layer.addSublayer(username_textFieldborder)
         username_textField.layer.masksToBounds = true
         
         
         let password_textFieldborder = CALayer()
         let password_textFieldwidth = CGFloat(1.0)
         password_textFieldborder.borderColor = UIColor.darkGrayColor().CGColor
         password_textFieldborder.frame = CGRect(x: 0, y: password_textField.frame.size.height - password_textFieldwidth, width:  password_textField.frame.size.width + 50, height: password_textField.frame.size.height)
         
         password_textFieldborder.borderWidth = password_textFieldwidth
         password_textField.layer.addSublayer(password_textFieldborder)
         password_textField.layer.masksToBounds = true */
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.username_textField.becomeFirstResponder()
        
//        self.username_textField.text = ""
//        self.username_textField.layer.borderColor = UIColor.clearColor().CGColor
//        self.username_errorLabel.text = ""
//        
//        self.password_textField.text = ""
//        self.password_textField.layer.borderColor = UIColor.clearColor().CGColor
//        self.password_errorLabel.text = ""
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

