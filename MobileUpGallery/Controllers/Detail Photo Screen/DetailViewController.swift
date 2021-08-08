//
//  DetailViewController.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 5.08.21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var fullPhotoImageView: CustomImageView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    var fullImageString = ""
    var date = 0
    var miniModel: [Item] = []
    var index = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = getReadableDate(date)
        fullPhotoImageView.loadImageUsingUrlStrting(urlString: fullImageString, view: self.view)
    }
    
    //MARK:- createActivityViewController
    func createActivityVC(index: IndexPath) {
        
        guard let image = fullPhotoImageView.image else { return }

        let url = miniModel[index.row].sizes.filter { $0.type == "m"}
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [image, url[0].url], applicationActivities: nil)
        
        activityViewController.activityItemsConfiguration = [ UIActivity.ActivityType.saveToCameraRoll ] as? UIActivityItemsConfigurationReading
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
//                self.createAlertView(title: "Произошла ошибка", massage: "Не удалось выполнить ваше действие") //я думаю пока это тут будет лишним
                return
            }
            self.createAlertView(title: "detaliAlertTitle".localized, massage: "")
        }
        
        activityViewController.popoverPresentationController?.sourceView = view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- Action
    @IBAction func scaleImage(_ sender: UIPinchGestureRecognizer) {
        fullPhotoImageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        createActivityVC(index: index)
    }
    
    //MARK:- createAllert
    func createAlertView(title: String, massage: String) {
        let allert = UIAlertController.init(title: title, message: massage, preferredStyle: .alert)
        let canceAction = UIAlertAction(title: "detailAlertButton".localized, style: .default, handler: nil)
        allert.addAction(canceAction)
        
        present(allert, animated: true, completion: nil)
    }
    
    //MARK:- convert Date
    func getReadableDate(_ value: Int) -> String? {
        
        let epocTime = TimeInterval(value)
        
        let date = Date(timeIntervalSince1970: epocTime)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "d MMMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}

//MARK:- extension DetailViewController UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miniModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bottomCell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: "bottomCell", for: indexPath) as! BottomCollectionViewCell
        let url = miniModel[indexPath.row].sizes.filter{ $0.type == "m"}
        bottomCell.imageView.loadImageUsingUrlStrting(urlString: url[0].url, view: bottomCell.contentView)
        return bottomCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath
        let url = miniModel[indexPath.row].sizes.filter{ $0.type == "z"}
        fullPhotoImageView.loadImageUsingUrlStrting(urlString: url[0].url, view: fullPhotoImageView)
        navigationItem.title = getReadableDate(miniModel[indexPath.row].date)
    }
}
