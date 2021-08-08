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
    @IBOutlet weak var logoutButtonOutlet: UIBarButtonItem!
    var model: Response = .init(items: [], count: 0)
    var activitiView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiView = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 20, height: 20))
        view.addSubview(activitiView)
        activitiView.startAnimating()
        navigationItem.title = "titleCollectionView".localized
        logoutButtonOutlet.title = "logoutButton".localized
        loadPhoto()
    }
    
    func loadPhoto() {
        VK.API.Photos.get([.ownerId: "-128666765", .albumId: "266276915"])
            .onSuccess { data in
                let json = try JSONDecoder().decode(Response.self, from: data)
                self.model = json
                DispatchQueue.main.async { [weak self] in
                    self?.activitiView.stopAnimating()
                    self?.activitiView.isHidden = true
                    self?.photoCollectionView.reloadData()
                }
            }
            .onError { error in
                DispatchQueue.main.async { [weak self] in
                    self?.activitiView.stopAnimating()
                    self?.activitiView.isHidden = true
                    self?.createAlertView(title: "collectionAlertTitle".localized, massage: "collectionAlertMessage".localized)
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
        let canceAction = UIAlertAction(title: "collectionAlertCancelButton".localized, style: .cancel, handler: nil)
        allert.addAction(canceAction)
        
        let action = UIAlertAction(title: "collectionAlertRefreshBurron".localized, style: .default) { _ in
            self.loadPhoto()
        }
        allert.addAction(action)
        
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
        cell.myImageView.loadImageUsingUrlStrting(urlString: String(describing: urlImageString[0].url), view: cell.contentView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let urlImageString = model.items[indexPath.row].sizes.filter{ $0.type == "z" }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
       
        detailVC.fullImageString = urlImageString[0].url
        detailVC.date = model.items[indexPath.row].date
        detailVC.miniModel = model.items
        detailVC.index = indexPath
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
