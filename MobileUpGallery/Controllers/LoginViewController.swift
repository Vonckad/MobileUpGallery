//
//  ViewController.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 3.08.21.
//

import UIKit
import SwiftyVK

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonOutlet.layer.cornerRadius = 8
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if VK.sessions.default.accessToken != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let gelerryVC = storyboard.instantiateViewController(identifier: "MyNavigationController") as! MyNavigationController
            self.present(gelerryVC, animated: false)
        }
    }
    
    @IBAction func loginButtonAtcion(_ sender: Any) {
        if VK.sessions.default.accessToken == nil {
            DispatchQueue.global().async {  [weak self] in
                VK.sessions.default.logIn { info in
                    
                    DispatchQueue.main.async { [weak self] in
                        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                        let gelerryVC = storyboard.instantiateViewController(identifier: "MyNavigationController") as! MyNavigationController
                        self?.present(gelerryVC, animated: true)
                    }
                    
                    print("SECSES", info)
                } onError: { error in
                    DispatchQueue.main.async { [weak self] in
                    self?.createAlertView(title: "Произошла ошибка!", massage: "Проверьте логин/пароль и попробуйте еще раз" )
                    }
                    print("ERROR", error)
                }
            }
           
        }
    }
    
    func createAlertView(title: String, massage: String) {
        let allert = UIAlertController.init(title: title, message: massage, preferredStyle: .alert)
        let canceAction = UIAlertAction(title: "Понятно", style: .default, handler: nil)
        allert.addAction(canceAction)
        
        present(allert, animated: true, completion: nil)
    }
}
