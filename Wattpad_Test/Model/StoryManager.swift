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
    
    static let shared = StoryManager()
    
    var storiesOffset = 0
    var storyLimitPerRequest = 9
    
    private lazy var baseURL: URL = {
        return URL(string: "https://www.wattpad.com")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
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
    
    //https://www.wattpad.com/api/v3/stories?offset=0&limit=30&fields=stories(id,title,cover,user)
    func getStories(completion: @escaping (_ stories: Stories?) -> Void){
        
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
        
        if let url = urlComponents.url {
            
            getData(from: url) { (data, response, error) in
                if let data = data{
                    if let stories = try? JSONDecoder().decode(Stories.self, from: data){
                        DispatchQueue.main.async {
                            completion(stories)
                        }
                    }else{
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
        
}


