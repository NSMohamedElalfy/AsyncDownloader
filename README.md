# AsyncDownloader
Easy way to asynchronously download resources ( image , JSON , XML , PDF , … etc) written in Swift

```swift
//initialize AsyncDownloader as lazy variable & config the NSURLSessionConfiguration to meet your best purpose 
lazy var downloader : AsyncDownloader = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        /// Cache; 100mb memory, 500mb disk. Be generous.
        let cache = NSURLCache(memoryCapacity: 100*1024*1024, diskCapacity: 500*1024*1024, diskPath: nil)
        config.requestCachePolicy = .ReturnCacheDataElseLoad
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.URLCache = cache
        sleep(1)
        return AsyncDownloader(configuration: config)
    }()
```

//then call download function to see the Magic easy ??

```swift
downloader.download(photo.remoteURL, onCompletion: { (result:Results) -> () in
            switch result{
                case let .Success(response):
                // do what you want with the response object :)
                    let image = response.getUIImage()!
                    // don't forget to update UI in the Main Queue ;)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.photoView.image = image
                        self.progressView.hidden = true
                })
                case let .Failure(error):
                // handle errors :(
                    print("error : \(error.localizedDescription)")
                }
            }, onProgress: { (progress:Float) -> () in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.progressView.setProgress(progress, animated: true)
                })
        })
```
