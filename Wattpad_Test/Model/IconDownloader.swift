//
//  IconDownloader.swift
//  Wattpad_Test
//
//  Created by Rupika Sompalli on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class IconDownloader: NSObject {
    
    var iconURL : URL
    var completionHandler : ((UIImage) -> Void)?
    var session : URLSessionDataTask?
    
    init(_ icnURL : URL) {
        self.iconURL = icnURL
        self.completionHandler = {_ in}
    }
    
    func startDownload(){
        
        DispatchQueue.global().async {
            
            self.session = URLSession.shared.dataTask(with: self.iconURL) { (responseData, responseUrl, error) -> Void in
                
                if let error = error as NSError?, error.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                    //not connected
                    abort()
                }
                
                // if responseData is not null...
                if let data = responseData {
                    if let img = UIImage(data: data){
                        if let completion = self.completionHandler{
                            completion(img)
                        }
                    }
                }
                
            }
            // Run task
            self.session?.resume()
            
        }
        
    }
    
    func cancelDownload(){
        self.session?.cancel()
        self.session = nil
    }
    
    
}
