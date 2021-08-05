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
    var model: Response = .init(items: [], count: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.init(name: "Galvji", size: 18)!], for: [.normal, .selected])
        
        VK.API.Photos.get([.ownerId: "-128666765", .albumId: "266276915"])
            .onSuccess { data in
                let json = try JSONDecoder().decode(Response.self, from: data)
                self.model = json
                DispatchQueue.main.async { [weak self] in
                    self?.photoCollectionView.reloadData()
                }
            }
            .onError { error in
                DispatchQueue.main.async { [weak self] in
                    self?.createAlertView(title: "Сбой загрузки", massage: "Обновите страницу")
                }
                print("errror", error)
            }
            .send()
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

extension GalleryNavigationController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (UIScreen.main.bounds.size.height - 3) / 3
        let width = (UIScreen.main.bounds.size.width - 2) / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let urlImageString = model.items[indexPath.row].sizes.filter { $0.type == "y" }
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        cell.myImageView.loadImageUsingUrlStrting(urlString: String(describing: urlImageString[0].url))
        
        return cell
    }
}
