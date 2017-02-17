//
//  ProfileViewController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 04/02/17.
//  Copyright © 2017 Atisha Poojary. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imagePicked: UIImageView!
    var imagePicker = UIImagePickerController()
    var imageData: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        imagePicker.delegate = self
        imagePicked.setRounded()
       
        if (UserDefaults.standard.string(forKey: "imageId") != nil){
            self.getProfilPic()
        }
        
//        if ((NSCache<AnyObject, AnyObject>().object(forKey:"profilePicture" as AnyObject)) != nil){
//            self.imagePicked.image = (NSCache<AnyObject, AnyObject>().object(forKey:"profilePicture" as AnyObject)) as? UIImage
//        }
    }

    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            DispatchQueue.main.async(execute: {
                self.imagePicked.contentMode = .scaleAspectFit
                self.imagePicked.image = pickedImage
            })
            self.dismiss(animated: true, completion: nil);
            
            imageData = UIImageJPEGRepresentation(pickedImage, 0.1) as NSData?

            self.convertImageDataToEncodedString {(strBase64) -> () in
                let type = self.imageType(imgData: imageData!)
                self.uploadImage(strBase64, imageType: type)
            }
        }
    }
    
    func convertImageDataToEncodedString(completion:((String) -> ())){
        let strBase64 = imageData!.base64EncodedString()
        completion(strBase64)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageType(imgData : NSData) -> String
    {
        var c = [UInt8](repeating: 0, count: 1)
        imgData.getBytes(&c, length: 1)
        
        let ext : String
        
        switch (c[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            ext = ""
        }
        return ext
    }
    

    func uploadImage(_ strBase64:String, imageType:String){
        let url: NSURL = NSURL(string:"http://69.164.208.35:8080/api/image/data")!
        let params = ["imageData":strBase64, "imageType":"JPEG"] as Dictionary<String, Any>

        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
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
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
                        if let dict = json as? NSDictionary {
                            if let status = dict["status"] as? Int {
                                print("status: \(status)")
                                DispatchQueue.main.async{
                                    if status == 200 {
                                       NSCache<AnyObject, AnyObject>().setObject(self.imagePicked.image!, forKey:"profilePicture" as AnyObject)
                                        UserDefaults.standard.set(dict["image"], forKey:"imageId")
                                    }
                                    else {
                                        ModelController().showToastMessage(message: dict["message"] as! String, view: self.view, y_coordinate: self.view.frame.size.height-85)
                                    }
                                }
                            }
                            return
                        }
                        else {
                            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    }
                }
            }
            catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }
    
    func getProfilPic()
    {
        let urlString = ("http://69.164.208.35:8080/api/image/\((UserDefaults.standard.string(forKey: "imageId"))!)")
        print("urlString\(urlString)")
        let url: URL = URL(string: urlString)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data! as Data, options:.allowFragments)
                if let dict = json as? NSDictionary {
                    
                    print("dict:'\(dict)")
                    
                    if(error != nil) {
                        print(error!.localizedDescription)
                        let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
                        if let dict = json as? NSDictionary {
                            if let status = dict["status"] as? Int {
                                DispatchQueue.main.async{
                                    if status == 200{
                                        let strBase64 = ((dict["image"] as AnyObject).object(forKey: "imageData") as! String)
                                        print("strBase64\(strBase64)")
                                        let imageData = NSData(base64Encoded: strBase64, options: .ignoreUnknownCharacters)
                                        self.imagePicked.image = UIImage.init(data: imageData as! Data)
                                    }
                                    else {
                                        ModelController().showToastMessage(message: "No internet connection.", view: self.view, y_coordinate: self.view.frame.size.height-85)
                                    }
                                }
                            }
                            return
                        }
                        else {
                            let jsonStr = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                            print("Error could not parse JSON: \(jsonStr)")
                        }
                    }
                }
            }catch let error as NSError {
                print("An error occurred: \(error)")
            }
        }
        task.resume()
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
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

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}



