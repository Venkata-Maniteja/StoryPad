
//
//  ViewController.swift
//  Wattpad_Test
//
//  Created by Venkata on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//


import Foundation
import UIKit

protocol StoryViewModelDelegate: class {
  func onFetchCompleted(with stories: [Story]?)
  func onFetchFailed(with reason: String)
  func onImageDownloaded(_ img : UIImage, _ indPath : IndexPath)
  func onStoriesFiltered()
}

final class StoryViewModel {
  private weak var delegate: StoryViewModelDelegate?
  
  private var stories: [Story] = []
    
  private var filteredStories : [Story] = []
  private var searchInProgress = false
    
  private var imageDownloadsInProgress : [IndexPath : IconDownloader]?

    
  private var total = 0
  private var isFetchInProgress = false
  
  let manager = StoryManager()
    
    private var currentPage : Int{
        return manager.storiesOffset + totalCount
    }
  
  init(delegate: StoryViewModelDelegate) {
    self.delegate = delegate
  }
  
  var totalCount: Int {
    return 27 //This is the total items returned by the wattpad api
  }
    
    var currentCount: Int {
        if searchInProgress == true{
            return filteredStories.count
        }
        return stories.count
    }
    
    var filterMode : Bool{
        return searchInProgress
    }
  
  func story(at index: Int) -> Story {
    if searchInProgress == true{
        return filteredStories[index]
    }
    return stories[index]
  }
  
  func fetchStories() {
   
    guard !isFetchInProgress else {
      return
    }
    
    isFetchInProgress = true
    
    guard let url = manager.buildURL() else{
        return
    }
    let request = URLRequest(url: url)
    manager.fetchStories(with: request, page: currentPage) { result in
     
        switch result {
          
          case .failure(let error):
                                            DispatchQueue.main.async {
                                              self.isFetchInProgress = false
                                              self.delegate?.onFetchFailed(with: error.reason)
                                            }
          case .success(let response):
                                            DispatchQueue.main.async {
                                              self.isFetchInProgress = false
                                              
                                              self.stories.append(contentsOf:response.stories!)
                                              
                                              if self.stories.isEmpty == true {
                                                self.delegate?.onFetchCompleted(with: .none)
                                              } else {
                                                self.delegate?.onFetchCompleted(with: response.stories)
                                              }
                                            }
      }
    }
  }
    
    
    // -------------------------------------------------------------------------------
    //    terminateAllDownloads
    // -------------------------------------------------------------------------------
    func terminateAllDownloads()
    {
        // terminate all pending download connections
        if let allDownloads = self.imageDownloadsInProgress?.values{
            for downloader in allDownloads{
                downloader.cancelDownload()
            }
        }
    }
    
     func startIconDownload(_ iconURL : String, indPath : IndexPath){
        
        if (imageDownloadsInProgress?[indPath]) != nil{
            //wait for the downloader to finish
        }else{
            //start the downloader
            guard let url = URL(string:iconURL) else{
                return
            }
            let downloader = IconDownloader(url)
            downloader.completionHandler = { img in
                
                self.updateDataSource(img, indPath)
                DispatchQueue.main.async {
                    self.delegate?.onImageDownloaded(img, indPath)
                }
                self.imageDownloadsInProgress?.removeValue(forKey: indPath)
                
            }
            self.imageDownloadsInProgress?[indPath] = downloader
            downloader.startDownload()
            
        }
        
    }
    
   private func updateDataSource(_ img : UIImage,_ indPath : IndexPath){
        
        if searchInProgress == false{
            var story = stories[indPath.row]
             story.coverImg = img
             stories[indPath.row] = story
        }else{
            var story = filteredStories[indPath.row]
            story.coverImg = img
            filteredStories[indPath.row] = story
        }
        
    }
    
    func textDidChange(_ searchText : String){
        
        if searchText.count > 0{
            searchInProgress = true
            
            filteredStories = stories.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
            print("search text is \(searchText)")
            self.delegate?.onStoriesFiltered()
        }else{
            searchDidStop()
        }
        
    }
    
    func searchDidStop(){
        searchInProgress = false
        self.delegate?.onStoriesFiltered()
        print(stories.count)
    }
 
  
}
