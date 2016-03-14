//
//  Extensions.swift
//  MindvalleyTestApp
//
//  Created by Mohamed El-Alfy on 3/12/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func URLFromString(parameters : [String:String]?) -> NSURL {
        if let parameters = parameters {
            let components = NSURLComponents(string: self)!
            var queryItems = [NSURLQueryItem]()
            
            for (key , value) in parameters {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            components.queryItems = queryItems
            return components.URL!
        }else{
            return NSURL(string: self)!
        }
    }
    
    func escape() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
        
        var escaped = ""
        
        if #available(iOS 8.3, OSX 10.10, *) {
            escaped = self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? self
        } else {
            let batchSize = 50
            var index = self.startIndex
            
            while index != self.endIndex {
                let startIndex = index
                let endIndex = index.advancedBy(batchSize, limit: self.endIndex)
                let range = Range(start: startIndex, end: endIndex)
                
                let substring = self.substringWithRange(range)
                
                escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
}


extension NSData {
    func fixJsonData() -> NSData? {
        var dataString = String(data: self, encoding: NSUTF8StringEncoding)!
        dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
        return dataString.dataUsingEncoding(NSUTF8StringEncoding)
    }
}
