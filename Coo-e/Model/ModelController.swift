//
//  ModelController.swift
//  Coo-e
//
//  Created by Atisha Poojary on 24/11/16.
//  Copyright © 2016 Atisha Poojary. All rights reserved.
//

import Foundation

public class ModelController{
    func showToastMessage(message: String, view: UIView) {
        DispatchQueue.main.async {
            let stringWidth = message.widthOfString(usingFont: UIFont.systemFont(ofSize: 14.5)) + 16
            let toastLabel = UILabel(frame: CGRect(origin: CGPoint(x:view.frame.size.width/2 - ((stringWidth+5)/2),y :view.frame.size.height-85), size: CGSize(width: stringWidth+5, height: 24)))
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
            
            view.addSubview(toastLabel)
            
            UIView.animate(withDuration: 3.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                toastLabel.alpha = 0.0
            }, completion: nil)
        }
    }
}

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

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
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
