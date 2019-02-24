//
//  StoryManager.swift
//  Wattpad_Test
//
//  Created by " on 05/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

class StoryManager {
    
    /**
     This var is used for pagination
     
     - Defualt value: 0
     
     */
    var storiesOffset = 0
    
    /**
     This var is used for limiting the number of items recieved from server
     
     - Defualt value: 9
     
     */
    var storyLimitPerRequest = 9
    
    private let session: URLSession
    
    /**
     This method initialises the Story manager by taking the URLSession as parameter
     
     - Returns: initialised manager class
     - Parameter session: URLSession
     
     */
    init(_ session: URLSession) {
        self.session = session
    }
    
    
    
    /**
     This method fetches the stories from the URL and returns the success/failure response through
     completion block
     
     - Returns: initialised manager class
     - Parameter request: URLRequest
     - Parameter page :  number for pagination
     - Parameter completion : sends Result type as parameter
     
     */
    func fetchStories(with request: URLRequest, page: Int, completion: @escaping (Result<Stories, DataResponseError>) -> Void) {
        
        session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,httpResponse.hasSuccessStatusCode,let data = data else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(Stories.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    
    /**
     This method builds the url that uses to make a netowrk request
     
     - Returns: A optional url with all the required query components
     
     */
    func buildURL() -> URL?{
        
        //creating a NSURL
        let scheme = "https"
        let host = "www.wattpad.com"
        let path = "/api/v3/stories"
        let queryItem1 = URLQueryItem(name: "offset", value: "\(storiesOffset)")
        let queryItem2 = URLQueryItem(name: "limit", value: "\(storyLimitPerRequest)")
        let queryItem3 = URLQueryItem(name: "fields", value: "stories(id,title,cover,user)")
        
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem1,queryItem2,queryItem3]
        
        return urlComponents.url
    }
    
    
}


