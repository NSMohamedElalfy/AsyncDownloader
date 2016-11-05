//
//  Photo.swift
//  AsyncDownloader
//
//  Created by NSMohamedElalfy on 10/31/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import Foundation

class Photo{
    
    var id:Int
    var previewURL : String
    var previewHeight :Int
    var webformatURL : String
    var userName : String
    var userImageURL : String
    
    init( id : Int , previewURL:String , previewHeight:Int , webformatURL:String , userName:String , userImageURL:String ){
        self.id = id ; self.previewHeight = previewHeight ; self.previewURL = previewURL ; self.userImageURL = userImageURL ; self.userName = userName; self.webformatURL = webformatURL;
    }
    
    convenience init(dictionary: [String:AnyObject]){
        let id = dictionary["id"] as? Int
        let previewURL = dictionary["previewURL"] as? String
        let previewHeight = dictionary["previewHeight"] as? Int
        let webformatURL = dictionary["webformatURL"] as? String
        let userName = dictionary["user"] as? String
        let userImageURL = dictionary["userImageURL"] as? String
    self.init(id:id! ,previewURL:previewURL!, previewHeight:previewHeight!,webformatURL:webformatURL!,userName:userName!,userImageURL:userImageURL!)
    }
    
}
