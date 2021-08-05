//
//  DataModel.swift
//  MobileUpGallery
//
//  Created by Vlad Ralovich on 5.08.21.
//

import Foundation

struct DataModel: Decodable {
    var response: Response
    
}

struct Response: Decodable {
    var items: [Item]
    var count: Int
}

struct Item: Decodable {
    var sizes: [Size]
}

struct Size: Decodable {
    var url: String
}
