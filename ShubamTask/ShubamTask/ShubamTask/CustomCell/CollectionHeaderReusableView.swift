//
//  CollectionHeaderReusableView.swift
//  ShubamTask
//
//  Created by Shubam Gupta on 24/07/20.
//  Copyright © 2020 Shubam. All rights reserved.
//

import UIKit

class CollectionHeaderReusableView: UICollectionReusableView {

    //MARK: Create Label
    private  let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    //MARK: Configure Label
    public func configure(msg: String) {
        backgroundColor = .white
        label.text = msg
        addSubview(label)
    }
    
    //MARK: layoutSubview
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 20, y: 6, width: UIScreen.main.bounds.size.width - 20, height: 40)
    }
}
