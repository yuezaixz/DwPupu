//
//  HomeItemListCollectionViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/21.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

class HomeItemListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var marketPriceLabel: UILabel!
    @IBOutlet weak var tag1Label: UILabel!
    @IBOutlet weak var tag2Label: UILabel!
    
    func setup(homeSubItem:HomeSubItem) {
        self.imageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/\(homeSubItem.imgUrl)"))
        self.nameLabel.text = homeSubItem.name
        self.priceLabel.text = "\(Float(homeSubItem.price/100))"
        self.marketPriceLabel.text = "\(Float(homeSubItem.marketPrice/100))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
