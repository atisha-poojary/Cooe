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
