//
//  ChatViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 09/01/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet var textFieldBottomConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Conversation"
        
        NotificationCenter.default.addObserver(self, selector:#selector(ChatViewController.handleKeyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(ChatViewController.handleKeyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Gesture recognizer
    func handleTap(_ recognizer: UITapGestureRecognizer){
        self.chatTextField.endEditing(true)
    }
    
    @IBAction func sendButtonClicked(_ sender: AnyObject) {
        
    }
    
    func handleKeyboardNotification (_ notification: Notification){
        if //let userInfo = (notification as NSNotification).userInfo{
            //let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue)?.cgRectValue
            let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            self.textFieldBottomConstraint!.constant = isKeyboardShowing ? (keyboardFrame.height) : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations:self.view.layoutIfNeeded, completion: {(completed) in
                
                if isKeyboardShowing {
                    /*
                     if (self.reverseArray.count != 0){
                     let indexPath = NSIndexPath(forItem: self.reverseArray.count-1, inSection: 1)
                     self.commentsTableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                     }
                     
                     */
                }
            })
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
