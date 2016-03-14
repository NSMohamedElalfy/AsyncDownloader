//
//  Photo.swift
//  PhotoMania
//
//  Created by Mohamed El-Alfy on 3/10/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import Foundation

class Photo : NSObject {
    
    let title:String
    let photoID:String
    let dateTaken : NSDate
    let farm:Int
    let server:String
    let secret:String
    var size:String = "m"
    
    var remoteURL:String {
        var _size:String = size
        if _size.isEmpty{
            _size = "m"
        }
        return "http://farm\(self.farm).staticflickr.com/\(self.server)/\(self.photoID)_\(self.secret)_\(_size).jpg"
    }

    init(title:String , photoID:String , dateTaken:NSDate , farm : Int , server : String , secret : String) {
        self.title = title
        self.photoID = photoID
        self.dateTaken = dateTaken
        self.farm = farm
        self.server = server
        self.secret = secret
        super.init()
    }
}





