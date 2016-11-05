//
//  AsyncDownloader.swift
//  AsyncDownloader
//
//  Created by NSMohamedElalfy on 10/30/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit
import Foundation

class AsyncDownloader: NSObject {

    typealias DownloaderCompletion = (Results)->()
    typealias DownloaderOnProgressCompletion = (Float)->()

    var timeoutIntervalForRequest:TimeInterval
    var requestCachePolicy:NSURLRequest.CachePolicy
    var allTasks = [URLSessionTask]()
    
    let configuration : URLSessionConfiguration
    let cache = NSCache<AnyObject, AnyObject>()
    
    lazy private var session:URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    // uses default configuration
    class var shared : AsyncDownloader {
        struct Static {
            static let instance = AsyncDownloader()
        }
        return Static.instance
    }
    
    init(configuration:URLSessionConfiguration = URLSessionConfiguration.default){
        self.configuration = configuration
        self.timeoutIntervalForRequest = configuration.timeoutIntervalForRequest
        self.requestCachePolicy = configuration.requestCachePolicy
        super.init()
    }
    
    
    func download(_ URLString:String ,parameters : [String : String]? = nil, onCompletion completionHandler:@escaping DownloaderCompletion){
        if URLString == "" {
            return
        }
        let url =   parameters != nil ?  URLString.URLFromString(parameters: parameters) : URL(string: URLString)
        DispatchQueue.global(qos: .background).async {
            let data = self.cache.object(forKey: url as AnyObject) as? Data
            if let goodData = data {
                DispatchQueue.main.async {
                    completionHandler(.success(Response(data: goodData)))
                }
                return
            }
        }
        
        let request = URLRequest(url: url!, cachePolicy: self.requestCachePolicy, timeoutInterval: self.timeoutIntervalForRequest)
        let task = self.session.downloadTask(with: request) { (url:URL?, response:URLResponse?, error:Error?) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode / 100 != 2 {
                        return
                    }
                    let goodData = try? Data(contentsOf: url!)
                    self.cache.setObject(goodData as AnyObject, forKey: url as AnyObject)
                    DispatchQueue.main.async {
                        completionHandler(.success(Response(data: goodData!)))
                        return
                    }
                }
            }
        }
        self.allTasks.append(task)
        task.resume()
    }
    
    func cancelDownloadTask(by url:URL){
        if #available(iOS 9.0, *) {
            self.session.getAllTasks { (tasks:[URLSessionTask]) in
                tasks.forEach({ (task:URLSessionTask) in
                    if let taskURL = task.originalRequest?.url {
                        if taskURL == url && task.state == .running{
                            task.cancel()
                        }
                    }
                    
                })
            }
        } else {
            // Fallback on earlier versions
            self.allTasks.forEach({ (task:URLSessionTask) in
                if let taskURL = task.originalRequest?.url {
                    if taskURL == url && task.state == .running{
                        task.cancel()
                    }
                }
            })
        }
    }
    
    func cancelAllDownloadTasks(){
        if #available(iOS 9.0, *) {
            self.session.getAllTasks { (tasks:[URLSessionTask]) in
                tasks.forEach({ (task:URLSessionTask) in
                    task.cancel()
                })
            }
        } else {
            // Fallback on earlier versions
            self.allTasks.forEach({ (task:URLSessionTask) in
                if task.state == .running {
                    task.cancel()
                }
            })
        }
    }
    
}








