//
//  HomeShopOtherBlockTableViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/21.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

class HomeShopOtherBlockTableViewCell: UITableViewCell {
    static let cellHeight: CGFloat = 566.0
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet var itemImageViews: [UIImageView]!
    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet var subNameLabels: [UILabel]!
    @IBOutlet var point1Labels: [UILabel]!
    @IBOutlet var point2Labels: [UILabel]!
    @IBOutlet var priceLabels: [UILabel]!
    @IBOutlet var marketPriceLabels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(homeItem: HomeItem) {
        self.bannerImageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/\(homeItem.imgUrl)"))
        homeItem.items.enumerated().forEach {[weak self] (index, subItem) in
            guard let self = self else { return }
            if index < self.nameLabels.count {
                self.itemImageViews[index].kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/\(subItem.imgUrl)"))
                self.nameLabels[index].text = subItem.name
                self.subNameLabels[index].text = subItem.subTitle
                self.priceLabels[index].text = "\(Float(subItem.price/100))"
                self.marketPriceLabels[index].text = "\(Float(subItem.marketPrice/100))"
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
}
