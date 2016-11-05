//
//  MainCollectionViewController.swift
//  AsyncDownloader
//
//  Created by NSMohamedElalfy on 10/31/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct API {
    static let baseURL = "https://pixabay.com/api/"
    static let key = "3644469-0fdfa9298029a80a49e59659a"
}

class MainCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var photos:[Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        self.fetchData(keyword: "malaysia")
    }
    
    
    func fetchData(keyword: String = "" , page:Int = 1 , perPage:Int = 20 ){
        photos.removeAll()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        AsyncDownloader.shared.cancelAllDownloadTasks()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
    
        // Configure the cell
        let photo = photos[indexPath.row]
        cell.userNameLabel.text = photo.userName
        cell.previewImageView.asyncImageLoader(url: photo.previewURL)
        cell.userImageView.asyncImageLoader(url: photo.userImageURL)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Define the initial state (Before the animation)
        cell.alpha = 0
        // Define the final state (After the animation)
        UIView.animate(withDuration: 0.7, animations: { cell.alpha = 1})
    }
    

}

extension MainCollectionViewController : UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            self.fetchData(keyword: text)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension MainCollectionViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        let photo = photos[indexPath.row]
        return CGFloat(photo.previewHeight)
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 60
    }
}



