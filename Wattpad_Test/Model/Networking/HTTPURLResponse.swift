//
//  StoryManager.swift
//  Wattpad_Test
//
//  Created by " on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//


import Foundation

extension HTTPURLResponse {
    
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
    
    var hasValidContentType : Bool{
        let content_type =  allHeaderFields["Content-Type"] as? String
        let expected_type = "application/json; charset=UTF-8"
        return content_type == expected_type
    }
    
}
