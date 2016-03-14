//
//  CharacterCollectionViewCell.swift
//  MindvalleyTestApp
//
//  Created by Mohamed El-Alfy on 3/12/16.
//  Copyright © 2016 Mohamed El-Alfy. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var photoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        photoView.image = nil
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            photoViewHeightConstraint.constant = attributes.photoHeight
        }
    }
    
}
