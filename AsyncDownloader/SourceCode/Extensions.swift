//
//  Extensions.swift
//  AsyncDownloader
//
//  Created by NSMohamedElalfy on 10/31/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func URLFromString(parameters : [String:String]?) -> URL {
        if let parameters = parameters {
            var components = URLComponents(string: self)!
            var queryItems = [URLQueryItem]()
            
            for (key , value) in parameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            components.queryItems = queryItems as [URLQueryItem]?
            return components.url! as URL
        }else{
            return URL(string: self)!
        }
    }
    
    func escape() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
    
    
}


extension Data {
    func fixJsonData() -> Data? {
        var dataString = String(data: self, encoding: String.Encoding.utf8)!
        dataString = dataString.replacingOccurrences(of:"\\'", with: "'")
        return dataString.data(using: String.Encoding.utf8)
    }
}


extension UIImageView {
    func asyncImageLoader(url:String){
        AsyncDownloader.shared.download(url) { (result:Results) in
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.image = response.getUIImage()
                }
            case let .failure(error):
                print(error.localizedDescription)
                self.image = nil
            }
        }
    }
    
}

