//
//  AsyncDownloadManager.swift
//  MindvalleyTestApp
//
//  Created by Mohamed El-Alfy on 3/12/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import Foundation
import UIKit


class Wrapper<T> {
    let p:T
    init(_ p:T){self.p = p}
}

public enum Results {
    case Success(Response)
    case Failure(NSError)
}

public class AsyncDownloader : NSObject , NSURLSessionDownloadDelegate {

    public typealias DownloaderCompletion = (Results)->()
    public typealias DownloaderOnProgressCompletion = (Float)->()
    
    public var activeTasks = [NSURLSessionTask]()
    
    private let configuration:NSURLSessionConfiguration
    private var timeoutIntervalForRequest:NSTimeInterval
    private var requestCachePolicy:NSURLRequestCachePolicy

    lazy private var session:NSURLSession = {
        let config = self.configuration
        let queue = NSOperationQueue()
        return NSURLSession(configuration: config, delegate: self, delegateQueue: queue)
    }()
    
    public init(configuration config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()){
        self.configuration = config
        self.timeoutIntervalForRequest = config.timeoutIntervalForRequest ?? 15
        self.requestCachePolicy = config.requestCachePolicy ??  .ReturnCacheDataElseLoad
        super.init()
    }
    
    
    public func download(URLString:String ,parameters : [String : String]? = nil, onCompletion completionHandler:DownloaderCompletion , onProgress progressHandler:DownloaderOnProgressCompletion) -> NSURLSessionTask {
        let url = URLString.URLFromString(parameters)
        let request = NSMutableURLRequest(URL: url , cachePolicy: self.requestCachePolicy , timeoutInterval: self.timeoutIntervalForRequest)
        NSURLProtocol.setProperty(Wrapper(completionHandler), forKey: "onCompletion", inRequest: request)
        NSURLProtocol.setProperty(Wrapper(progressHandler), forKey: "onProgress", inRequest: request)
        let task = self.session.downloadTaskWithRequest(request)
        task.resume()
        self.activeTasks.append(task)
        return task
    }
    
    public func download(URLString:String ,parameters : [String : String]? = nil, onCompletion completionHandler:DownloaderCompletion) -> NSURLSessionTask{
        let url = URLString.URLFromString(parameters)
        let request = NSMutableURLRequest(URL: url , cachePolicy: self.requestCachePolicy , timeoutInterval: self.timeoutIntervalForRequest)
        NSURLProtocol.setProperty(Wrapper(completionHandler), forKey: "onCompletion", inRequest: request)
        let task = self.session.downloadTaskWithRequest(request)
        task.resume()
        self.activeTasks.append(task)
        return task
    }

    public func cancelTask(url:NSURL){
        if #available(iOS 9.0, *) {
            self.session.getAllTasksWithCompletionHandler { (tasks:[NSURLSessionTask]) -> Void in
                for task in tasks {
                    if task.originalRequest?.URL == url{
                        task.cancel()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            for task in activeTasks {
                if task.originalRequest?.URL == url{
                    task.cancel()
                }
            }
        }
    }
    
    public func cancelAllTasks(){
        self.activeTasks.removeAll()
        self.session.invalidateAndCancel()
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let request = downloadTask.originalRequest!
        let successHandler:AnyObject = NSURLProtocol.propertyForKey("onCompletion", inRequest: request)!
        let response = downloadTask.response as! NSHTTPURLResponse
        let stat = response.statusCode
        var url : NSURL! = nil
        if stat == 200 {
            url = location
            let finalOnSuccess = (successHandler as! Wrapper).p as DownloaderCompletion
            let data = NSData(contentsOfURL: url)
            let res = Response(data: data!)
            finalOnSuccess(.Success(res))
        }
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        let request = task.originalRequest!
        /*if let index = self.activeTasks.indexOf(task) where task.originalRequest == request && !(index < 0){
            self.activeTasks.removeAtIndex(index)
        }*/
        if error != nil {
            let failureHandler :AnyObject = NSURLProtocol.propertyForKey("onCompletion", inRequest: request)!
            let finalOnFailure = (failureHandler as! Wrapper).p as DownloaderCompletion
            finalOnFailure(.Failure(error!))
        }
    }
    
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let request = downloadTask.originalRequest!
        guard let progressHandler:AnyObject = NSURLProtocol.propertyForKey("onProgress", inRequest: request) else{
            return
        }
        let finalOnProgress = (progressHandler as! Wrapper).p as DownloaderOnProgressCompletion
        let bytes = 100*totalBytesWritten/totalBytesExpectedToWrite
        finalOnProgress(Float(bytes))
    }
    
}



