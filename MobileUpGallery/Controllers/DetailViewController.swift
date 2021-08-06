//
//  DetailViewController.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 5.08.21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var fullPhotoImageView: CustomImageView!
    
    var fullImageString = ""
    var date = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = getReadableDate(date)
        fullPhotoImageView.loadImageUsingUrlStrting(urlString: fullImageString)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            self.createAlertView(title: "Готово", massage: "Изображение сохранено в галерею")
        }
        
        imageSaver.errorHandler = {
            self.createAlertView(title: "Ошибка", massage: "Не удается сохранить изображение в галерею")
        }
        
        imageSaver.writeToPhotoAlbum(image: fullPhotoImageView.image!)
        
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

//MARK:- ImageSaveClass
class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler: (() -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            errorHandler?()
        } else {
            successHandler?()
        }
    }
}
