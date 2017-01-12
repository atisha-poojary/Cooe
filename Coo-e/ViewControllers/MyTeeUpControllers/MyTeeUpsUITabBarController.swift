//
//  MyTeeUpsUITabBarController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 12/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class MyTeeUpsUITabBarController: UITabBarController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
                //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

