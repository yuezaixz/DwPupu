//
//  CategoryMainTopCollectionViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/22.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import Gifu
import SnapKit

class CategoryMainTopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var gifImageView:GIFImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.showImage(isGif: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gifImageView = GIFImageView()
        self.imageView.superview?.addSubview(gifImageView)
        gifImageView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            make.top.equalTo(self.imageView.snp.top)
            make.left.equalTo(self.imageView.snp.left)
            make.right.equalTo(self.imageView.snp.right)
            make.bottom.equalTo(self.imageView.snp.bottom)
        }
        gifImageView.isHidden = true
        // Initialization code
    }
    
    public func showImage(isGif:Bool) {
        gifImageView.isHidden = !isGif
        imageView.isHidden = isGif
    }

}
