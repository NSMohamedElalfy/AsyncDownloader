//
//  RecentCollectionViewController.swift
//  MindValleyTest
//
//  Created by Mohamed El-Alfy on 3/14/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import UIKit

private struct Idenifires {
    static let cellID = "PhotoCellD"
    static let segueID = "ShowPhotoDetails"
}

class RecentCollectionViewController: UICollectionViewController {
    
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
    
    var photos = [Photo]()
    
    let refreshCtrl = UIRefreshControl()
    let spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        spinner.activityIndicatorViewStyle = .Gray
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        self.parentViewController?.view.addSubview(spinner)
        spinner.startAnimating()
        
        refreshCtrl.addTarget(self, action: "startRefresh", forControlEvents: .ValueChanged)
        collectionView?.addSubview(refreshCtrl)
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        startRefresh()
    }
    
    func startRefresh(){
        fetchRecentPhotos(page , perPage:40)
        page += 1
    }
    
    func fetchRecentPhotos(page:Int , perPage:Int){
        self.downloader.download(FlickrAPI.baseURLString, parameters: FlickrAPI.getParameters(page, perPage: perPage)) { (result:Results) -> () in
            switch result{
            case let .Success(response):
                /*FlickrAPI.photosFromJsonData(response.getJSON()!)?.forEach({ (photo) -> () in
                    self.photos.append(photo)
                })*/
                self.photos = FlickrAPI.photosFromJsonData(response.getJSON()!)!
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.collectionView?.reloadData()
                    self.spinner.stopAnimating()
                    self.refreshCtrl.endRefreshing()
                })
            case let .Failure(error):
                print("error : \(error.localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == Idenifires.segueID {
            let desVC = segue.destinationViewController as! PhotoDetailsViewController
            if let senders = sender as? [AnyObject]{
                desVC.photo = senders[0] as? Photo
                desVC.downloader = senders[1] as? AsyncDownloader
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Idenifires.cellID, forIndexPath: indexPath) as! PhotoCollectionViewCell
    
        // Configure the cell
        let photo = self.photos[indexPath.row]
        cell.photoTitleLabel.text = photo.title
        downloader.download(photo.remoteURL) { (result:Results) -> () in
            switch result{
            case let .Success(response):
                let image = response.getUIImage()!
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    cell.photoView.image = image
                    cell.indicator.stopAnimating()
                })
            case let .Failure(error):
                print("error : \(error.localizedDescription)")
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo = self.photos[indexPath.row]
        performSegueWithIdentifier(Idenifires.segueID, sender: [photo,downloader])
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.alpha = 0
        UIView.animateWithDuration(0.5) { () -> Void in
            cell.alpha = 1
        }
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}


extension RecentCollectionViewController : PinterestLayoutDelegate {
    // 1
    
    // provides height of the photos
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath, withWidth width:CGFloat) -> CGFloat {
        return 140
    }
    
    // 2
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 60
    }
}

