//
//  ViewController.swift
//  Wattpad_Test
//
//  Created by Venkata on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

extension String {
 
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
  
    func hasSpecialCharacters() -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }   
}
