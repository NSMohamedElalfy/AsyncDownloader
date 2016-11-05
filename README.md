# AsyncDownloader
Easy way to asynchronously download resources ( image , JSON , XML , PDF , … etc) written in Swift

```swift
AsyncDownloader.shared.download(API.baseURL, parameters: [
            "key":API.key,
            "q" : "\(keyword.replacingOccurrences(of: " ", with: "+"))",
            "lang" : "en",
            "image_type" : "all",
            "page" : "\(page)",
            "per_page" : "\(perPage)"
        ]) { (result:Results) in
            switch result {
            case let .success(response):
                if let json = response.getJSON() {
                    let hits = json["hits"] as! [[String:AnyObject]]
                    for hit in hits {
                        let photo = Photo(dictionary: hit)
                        self.photos.append(photo)
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
        // and there is an extension for UIImageView
        cell.imageView.asyncImageLoader(url: photo.previewURL)
```
