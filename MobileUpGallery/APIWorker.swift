//
//  APIWorker.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 3.08.21.
//

import Foundation
import SwiftyVK


final class APIWorker {
    
    class func action(_ tag: Int) {
        switch tag {
        case 1:
            authorize()
        case 2:
            logout()
        default:
            print("Unrecognized action!")
        }
    }
    
    class func authorize() {
        VK.sessions.default.logIn(
            onSuccess: { info in
                print("SwiftyVK: success authorize with", info)
            },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
            }
        )
    }
    
    class func logout() {
        VK.sessions.default.logOut()
        print("SwiftyVK: LogOut")
    }
}
