//
//  DetailViewController.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 5.08.21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var fullPhotoImageView: CustomImageView!
    @IBOutlet weak var titleDatePhoto: UINavigationItem!
    
    var fullImageString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullPhotoImageView.loadImageUsingUrlStrting(urlString: fullImageString)
        
    }
   
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func shareButton(_ sender: Any) {
        print("Action")
    }
}
