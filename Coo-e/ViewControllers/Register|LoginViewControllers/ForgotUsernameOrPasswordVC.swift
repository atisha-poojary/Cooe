//
//  ForgotUsernameOrPasswordVC.swift
//  Coo-e
//
//  Created by Atisha Poojary on 14/10/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class ForgotUsernameOrPasswordVC: UIViewController {

    @IBOutlet weak var email_textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonClicked(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendUsernameClicked(sender: AnyObject) {
        _ = email_textField.text!
    }
    
    @IBAction func resetPasswordClicked(sender: AnyObject) {
        _ = email_textField.text!
        
        let urlString = "http://resources.coo-e.com:8080/cooe/profile/\(UserDefaults.standard.integer(forKey: "userName"))/forgotPassword/EMAIL"
        
        let url: NSURL = NSURL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                DispatchQueue.main.async{
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
     
        }
        task.resume()
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
