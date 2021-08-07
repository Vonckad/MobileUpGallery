//
//  CustomImageView.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 5.08.21.
//

import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    var activitiView = UIActivityIndicatorView()
    
    func loadImageUsingUrlStrting(urlString: String, view: UIView) {
        
        activitiView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        view.addSubview(activitiView)
        activitiView.startAnimating()
        
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache
            return
        }

        URLSession.shared.dataTask(with: url!) { (data, respones, error) in
            if error != nil {
//                self.activitiView.isHidden = false
//                self.activitiView.startAnimating()
//                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                
                self.activitiView.isHidden = true
                self.activitiView.stopAnimating()
                
                let imageToCache = UIImage(data: data!)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                if let un = imageToCache {
                    imageCache.setObject(un, forKey: urlString as AnyObject)
                }
            }
        }
        .resume()
    }
}
