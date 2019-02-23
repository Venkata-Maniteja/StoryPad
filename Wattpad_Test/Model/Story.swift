//
//  Story.swift
//  Wattpad_Test
//
//  Created by " on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//


import Foundation
import UIKit

struct Stories : Codable{
    
    var stories : [Story]?
   
    enum CodingKeys : String,CodingKey{
        case stories = "stories"
    }
}

struct Story : Codable {
    
    var id : String?
    var title : String?
    var user : User?
    var cover : String?
    var coverImg : UIImage?
    
    enum CodingKeys : String, CodingKey{
        case id = "id"
        case title = "title"
        case user = "user"
        case cover = "cover"
    }
    
}


struct User : Codable{
    var name : String?
    var avatar : String?
    var fullname : String?
    
    enum CodingKeys : String, CodingKey{
        case name = "name"
        case avatar = "avatar"
        case fullname = "fullname"
    }
}
