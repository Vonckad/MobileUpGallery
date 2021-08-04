//
//  GalleryNavigationController.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 4.08.21.
//

import UIKit
import SwiftyVK

class MyNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class GalleryNavigationController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true)
            VK.sessions.default.logOut()
    }
    
    func createAlertView(title: String, massage: String) {
        let allert = UIAlertController.init(title: title, message: massage, preferredStyle: .alert)
        let canceAction = UIAlertAction(title: "Понятно", style: .default, handler: nil)
        allert.addAction(canceAction)
        
        present(allert, animated: true, completion: nil)
    }
}

extension GalleryNavigationController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
