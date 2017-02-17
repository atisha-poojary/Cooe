//
//  WhenSuggestionsViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 14/02/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class WhenSuggestionsViewController: UIViewController {
    var teeUp_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWhenSuggestiosn(teeUp_id)
        // Do any additional setup after loading the view.
    }
    
    func getWhenSuggestiosn(_ teeUp_id:String){
        let url: URL = URL(string: "http://69.164.208.35:8080/api/teeups/\(teeUp_id)/when")!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            let strData = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            print("when: \(strData)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    if let status = dict["status"] as? Int {
                        if status == 200{

                        }
                    }
                    return
                }
            }catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "TeeUp"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
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
