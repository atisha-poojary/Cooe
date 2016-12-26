//
//  ModelController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 24/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import Foundation

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync() {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    public func setRounded() {
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension UIView {
    public func setRoundedCorners() {
        self.layer.cornerRadius = self.frame.width / 9
        self.layer.cornerRadius = self.frame.width / 9
        self.clipsToBounds = true
    }
    
//    public func addShawdow() {
//        self.layer.masksToBounds = NO;
//        self.layer.cornerRadius = 8;
//        self.shadowOffset = CGSizeMake(5.0, 5.0);
//        self.shadowRadius = 5;
//        self.shadowOpacity = 0.5;
//    }
}
