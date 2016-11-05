//
//  Response.swift
//  AsyncDownloader
//
//  Created by NSMohamedElalfy on 10/31/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import Foundation
import UIKit


class Response : NSObject {
    
    var data:Data?
    
    public init(data:Data) {
        self.data = data
    }
    
}


extension Response {
    
    public func getJSON() -> [String : AnyObject]? {
        if let data = self.data {
            do{
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options:[])
                return jsonDictionary as? [String:AnyObject]
            }catch{
                print("Error on JSON Serialization")
                return nil
            }
        }else{
            print("Error : Data not found")
            return nil
        }
    }
    
    public func getUIImage() -> UIImage? {
        if let data = self.data {
            return UIImage(data: data)
        }else{
            print("Error : Data not found")
            return nil
        }
    }
    
    public func getNSData()-> Data?{
        if let data = self.data {
            return data
        }else{
            print("Error : Data not found")
            return nil
        }
    }
}
