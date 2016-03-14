//
//  PhotoDetailsViewController.swift
//  MindValleyTest
//
//  Created by Mohamed El-Alfy on 3/14/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoView:UIImageView!
    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var photo:Photo?
    var downloader:AsyncDownloader?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let ph = self.photo ,
            down = self.downloader else{
                return
        }
        
        self.textView.text = ph.title
        ph.size = "h"
        down.download(ph.remoteURL, onCompletion: { (result:Results) -> () in
            switch result{
                case let .Success(response):
                    let image = response.getUIImage()!
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.photoView.image = image
                        self.progressView.hidden = true
                })
                case let .Failure(error):
                    print("error : \(error.localizedDescription)")
                }
            }, onProgress: { (progress:Float) -> () in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.progressView.setProgress(progress, animated: true)
                })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
