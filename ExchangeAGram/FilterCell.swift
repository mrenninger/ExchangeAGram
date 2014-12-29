//
//  FilterCell.swift
//  ExchangeAGram
//
//  Created by Michael Renninger on 12/12/14.
//  Copyright (c) 2014 Michael Renninger. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    // Variables
    var imageView: UIImageView!
    
    
    
    // Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imageView)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
