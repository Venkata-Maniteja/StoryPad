//
//  StoryManager.swift
//  Wattpad_Test
//
//  Created by " on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//


import Foundation

enum Result<T, U: Error> {
  case success(T)
  case failure(U)
}
