
//
//  ViewController.swift
//  Wattpad_Test
//
//  Created by Venkata on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//


import Foundation
import UIKit


final class StoryViewModel {
    private weak var delegate: StoryViewModelDelegate?
    
    private var stories: [Story] = []
    
    private var filteredStories : [Story] = []
    private var searchInProgress = false
    
    /**
     This var is used for storing the image cache.
     This is used to track the images that needs to be downloaded
     
     */
    private var imageDownloadsInProgress : [IndexPath : IconDownloader]?
    
    
    private var total = 0
    private var isFetchInProgress = false
    
    private let session = URLSession()
    let manager : StoryManager
    
    /**
     This value represents the page number used in making network request.
     This is for pagination.
     
     */
    private var currentPage : Int{
        return manager.storiesOffset + totalCount
    }
    
    /**
     This value represents is search modes is enabled or not.
     
     */
     var isSearchInProgress : Bool{
        return searchInProgress
     }
    
    /**
     This value represents count of filtered stories
     
     */
    var filterCount : Int{
        return filteredStories.count
    }
    
    
    /**
     This method initialises the StoryViewModel
     
     - Parameter delegate: The delegate for the view model
     - Returns : Initialised view model class object
     */
    init(delegate: StoryViewModelDelegate) {
        self.delegate = delegate
        let session = URLSession.shared
        manager = StoryManager(session)
        
    }
    
    /**
     This value represents the total number of stories that willcome from the servrer.
     
     */
    var totalCount: Int {
        return 27 //This is the total items returned by the wattpad api
    }
    
    
    /**
     This value represents the current count of stories that are downloaded.
     
     */
    var currentCount: Int {
//        if searchInProgress == true{
//            return filteredStories.count
//        }
        return stories.count
    }
    
    
    /**
     This method returns the story item from datasource.
     
     - Parameter index: The index of story item
     - Returns : Story item from the array
     */
    func story(at index: Int) -> Story {
        if searchInProgress == true{
            return filteredStories[index]
        }
        return stories[index]
    }
    
    
    /**
     This method initiates the story fetch
     
     */
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
    
    
    /**
     This method is used to cancell all downloads that are in progress.
     
     */
    func terminateAllDownloads()
    {
        // terminate all pending download connections
        if let allDownloads = self.imageDownloadsInProgress?.values{
            for downloader in allDownloads{
                downloader.cancelDownload()
            }
        }
    }
    
    /**
     This method downloads the icon for the story
     
     - Parameter iconURL: The icon url for story cover image
     - Parameter indPath: The indexpath for story item in the list view
     */
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
    
    /**
     This method updates the data source with the image that is downloaded
     
     - Parameter img: The image that is downloaded
     - Parameter indPath: The indexpath for story item in the list view
     */
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
    
    
    /**
     This method gets called when user types in the search bar
     
     - Parameter searchText: The text in the search bar
     */
    func textDidChange(_ searchText : String){
        
        if searchText.count > 0{
            searchInProgress = true
            filteredStories.removeAll()
            filteredStories = stories.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
            print("search text is \(searchText), filter count : \(filteredStories.count)")
            self.delegate?.onStoriesFiltered()
        }else{
            searchDidStop(searchText)
        }
        
    }
    
    /**
     This method gets called when user search bar did end editing
     
     */
    func searchDidStop(_ searchText : String){
        
        if searchText.isEmpty {
            searchInProgress = false
        }
        self.delegate?.onStoriesFiltered()
        print(stories.count)
    }
    
    
}
