//
//  Response.swift
//  MindvalleyTestApp
//
//  Created by Mohamed El-Alfy on 3/13/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import Foundation
import UIKit


public class Response : NSObject {
    
    var data:NSData?
    
    public init(data:NSData) {
        self.data = data
    }
    
    
    public func getJSON() -> [String : AnyObject]? {
        if let data = self.data {
            do{
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options:[])
                return jsonDictionary as? [String:AnyObject]
            }catch{
                print("Error on JSON Serialization")
                return nil
            }
        }else{
            print("Error : NSData not found")
            return nil
        }
    }
    
    public func getUIImage() -> UIImage? {
        if let data = self.data {
            return UIImage(data: data)
        }else{
            print("Error : NSData not found")
            return nil
        }
    }
    
    public func getNSData()-> NSData?{
        if let data = self.data {
            return data
        }else{
            print("Error : NSData not found")
            return nil
        }
    }
    
}