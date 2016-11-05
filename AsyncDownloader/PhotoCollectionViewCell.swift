//
//  PhotoCollectionViewCell.swift
//  AsyncDownloader
//
//  Created by NSMohamedElalfy on 10/31/16.
//  Copyright © 2016 NSMohamedElalfy. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func prepareForReuse() {
        previewImageView.image = nil
        userImageView.image = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }

    
    
}
