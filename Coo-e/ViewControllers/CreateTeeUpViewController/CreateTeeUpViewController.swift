//
//  CreateTeeUpViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 04/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class CreateTeeUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var title_textField: UITextField!
    @IBOutlet weak var message_textView: UITextView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title_textField.becomeFirstResponder()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
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
