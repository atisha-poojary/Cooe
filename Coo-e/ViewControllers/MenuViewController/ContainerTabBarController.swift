//
//  ContainerTabBarController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 13/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import UIKit

class ContainerTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var centerNavigationController: UINavigationController!
        var centerViewController: MyTeeUpsUITabBarController!
        
        centerViewController = UIStoryboard.centerViewController()
        //centerViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
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


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func leftViewController() -> MenuViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? MenuViewController
    }
    
    class func centerViewController() -> MyTeeUpsUITabBarController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? MyTeeUpsUITabBarController
    }
    
}
