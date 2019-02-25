//
//  StoryManager.swift
//  Wattpad_Test
//
//  Created by Venkata Nandamuri on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation

enum DataResponseError: Error {
  case network
  case decoding
  
  var reason: String {
    switch self {
    case .network:
      return "An error occurred while fetching data ".localizedString
    case .decoding:
      return "An error occurred while decoding data".localizedString
    }
  }
}
