//
//  StoryViewModelDelegate.swift
//  Wattpad_Test
//
//  Created by Venkata Nandamuri on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol handles the data download communication between ViewController and its ViewModel
 
 */
protocol StoryViewModelDelegate: class {
    
    /**
     This method is called when stories are downloaded.
     
     - Parameter stories: An array of Story items
     */
    func onFetchCompleted(with stories: [Story]?)
    
    /**
     This method is called when story fetch is failed
     
     - Parameter reason: Localised error message
     */
    func onFetchFailed(with reason: String)
    
    /**
     This method is called when cover image is downloaded for a story item.
     
     - Parameter img: Downloaded cover image for story
     - Parameter indPath: Indexpath for the story item on thelistview
     */
    func onImageDownloaded(_ img : UIImage, _ indPath : IndexPath)
    
    /**
     This method is called when user is searching for stories using searchbar
     
     */
    func onStoriesFiltered()
}
