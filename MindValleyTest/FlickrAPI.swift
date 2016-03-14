//
//  FlickerAPI.swift
//  PhotoMania
//
//  Created by Mohamed El-Alfy on 3/9/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import Foundation



struct FlickrAPI {
    
    static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "4f6675d6b5b24c2d5b15eaa50e91930e"
    private static let APIMethod = "flickr.photos.getRecent"
    
    
    private static let dateFormatter : NSDateFormatter = {
       let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static func getParameters(page:Int = 1 , perPage:Int = 100) -> [String:String]?{
        
        return [
            "method": APIMethod ,
            "format" : "json" ,
            "nojsoncallback" : "1" ,
            "api_key" : APIKey ,
            "extras":"date_taken",
            "per_page":"\(perPage)",
            "page":"\(page)"
        ]
        
    }
    
    private static func photoFromJSONObject(json:[String: AnyObject]) -> Photo? {
        guard let photoID = json["id"] as? String,
            title = json["title"] as? String,
            dateString = json["datetaken"] as? String,
            farm = json["farm"] as? Int ,
            server = json["server"] as? String,
            secret = json["secret"] as? String,
        dateTaken = dateFormatter.dateFromString(dateString) else{
                return nil
        }
        return Photo(title: title, photoID: photoID, dateTaken: dateTaken, farm: farm, server: server, secret: secret)
    }
    
    static func photosFromJsonData(data:[String:AnyObject]) -> [Photo]? {
            guard let photos = data["photos"] as? [String : AnyObject] ,
                photosArray = photos["photo"] as? [[String : AnyObject]] else {
                //The JSON structure doesn't match our expectations
               return nil
            }
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photoFromJSONObject(photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            if finalPhotos.count == 0 && photosArray.count > 0 {
                // We weren't able to parse any of the photos
                // Maybe the JSON Format for photos has changed
                return nil
            }
            return finalPhotos
    }
    
}
