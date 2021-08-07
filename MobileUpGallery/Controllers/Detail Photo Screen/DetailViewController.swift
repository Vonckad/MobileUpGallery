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
    var miniModel: [Item] = []//.init(url: "", type: "")
    
//    var imageArray: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = getReadableDate(date)
        fullPhotoImageView.loadImageUsingUrlStrting(urlString: fullImageString, view: self.view)
    }
    
    //MARK:- Action
    @IBAction func scaleImage(_ sender: UIPinchGestureRecognizer) {
        fullPhotoImageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            self.createAlertView(title: "Готово", massage: "Изображение сохранено в галерею")
        }
        
        imageSaver.errorHandler = {
            self.createAlertView(title: "Ошибка", massage: "Не удается сохранить изображение в галерею")
        }
        
        guard let image = fullPhotoImageView.image else { return }
        imageSaver.writeToPhotoAlbum(image: image)
        
    }
    
    //MARK:- createAllert
    func createAlertView(title: String, massage: String) {
        let allert = UIAlertController.init(title: title, message: massage, preferredStyle: .alert)
        let canceAction = UIAlertAction(title: "Понятно", style: .default, handler: nil)
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
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
}

//MARK:- UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miniModel.count//imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bottomCell = bottomCollectionView.dequeueReusableCell(withReuseIdentifier: "bottomCell", for: indexPath) as! BottomCollectionViewCell
        let url = miniModel[indexPath.row].sizes.filter{ $0.type == "m"}
        bottomCell.imageView.loadImageUsingUrlStrting(urlString: url[0].url, view: bottomCell.contentView)
        return bottomCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = miniModel[indexPath.row].sizes.filter{ $0.type == "z"}
        fullPhotoImageView.loadImageUsingUrlStrting(urlString: url[0].url, view: UIView())
        
    }
    
}
