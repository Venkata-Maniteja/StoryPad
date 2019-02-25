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
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stories = try container.decode([Story].self, forKey: .stories) 
        
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
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id) //Shouldnt this be Int ?
        
        guard let idNum = Int(self.id ?? "0"), idNum > 0 && idNum <= Int32.max else{
          throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "Unexpected id value, or id is nill")
        }
        
        self.title = try container.decode(String.self, forKey: .title) //Should cover title contain special chars ?
        //TODO: special validation for cover titles which has special characters
        
        
        self.user = try container.decode(User.self, forKey: .user)
        
        self.cover = try container.decode(String.self, forKey: .cover)
        guard let cover = self.cover, let coverURL = URL(string:cover),coverURL.host == "a.wattpad.com"  else{
            throw DecodingError.dataCorruptedError(forKey: .cover, in: container, debugDescription: "Cover url is invalid")
        }
       
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
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        self.name = try container.decode(String.self, forKey: .name) //Should name contain special chars ? like kittygirl_1234?
        //TODO: special validation for usernames
        
        self.fullname = try container.decode(String.self, forKey: .fullname) //Should name contain special chars ? like kittygirl_1234 ?
//        guard let fName = self.fullname, fName.hasSpecialCharacters() == false  else{
//            throw DecodingError.dataCorruptedError(forKey: .fullname, in: container, debugDescription: "Full Name contain unexpected chars")
//        }
        
        self.avatar = try container.decode(String.self, forKey: .avatar)
        guard let avatar = self.avatar, let avatarURL = URL(string:avatar),avatarURL.host == "a.wattpad.com"  else{
            throw DecodingError.dataCorruptedError(forKey: .avatar, in: container, debugDescription: "Cover url is invalid")
        }
        
    }
}
