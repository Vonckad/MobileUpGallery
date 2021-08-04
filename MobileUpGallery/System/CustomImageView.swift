//
//  CustomImageView.swift
//  WhiteStar
//
//  Created by Vlad Ralovich on 2/1/21.
//

import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlStrting(urlString: String) {
        
        imageUrlString = urlString
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache
            return
        }

        URLSession.shared.dataTask(with: url!) { (data, respones, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
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
