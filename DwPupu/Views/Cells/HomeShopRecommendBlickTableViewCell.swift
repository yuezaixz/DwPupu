//
//  HomeShopRecommendBlickTableViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/19.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import SnapKit

class HomeShopRecommendBlickTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private let containerPadding:CGFloat = 15.0
    private let pagePadding:CGFloat = 8.0
    private let itemPadding:CGFloat = 4.0
    private let heightWidthDiv = CGFloat(260/384)
    private let pageMarginTop:CGFloat = 36.0
    private let itemMarginBottom:CGFloat = 20.0
    
    func setup() {
        let autoScrollView = LTAutoScrollView()
        self.containerView.addSubview(autoScrollView)
        autoScrollView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        let width = DwScreen.width - containerPadding*2
        let height = heightWidthDiv * width
        
        let pageViewHeight = height - pageMarginTop
        let itemViewWidth = (width-pagePadding*2-itemPadding*2)/3
        let itemViewHeight = pageViewHeight - itemMarginBottom
        
        autoScrollView.isAutoScroll = false
        autoScrollView.autoViewHandle = {[weak self] in
            var results:[UIView] = []
            guard let self = self else {
                return results
            }
            for _ in [0..<5] {
                let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: pageViewHeight))
                results.append(view)
                view.backgroundColor = UIColor.clear
                var offsetX = self.pagePadding
                for _ in [0..<3] {
                    let itemView = UIView(frame: CGRect(x: offsetX, y: 0.0, width: itemViewWidth, height: itemViewHeight))
                    itemView.backgroundColor = UIColor.white
                    itemView.layer.cornerRadius = 6.0
                    
                    
                    offsetX += itemViewWidth + self.itemPadding
                }
            }
            return results
        }
        autoScrollView.scrollDirection = .horizontal
//        autoScrollView.images = images
//        autoScrollView.imageHandle = {(imageView, imageName) in
//            imageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/".appending(imageName)))
//        }
        autoScrollView.gltPageControlHeight = 20

        //设置LTDotLayout，更多dot使用见LTDotLayout属性说明
        let layout = LTDotLayout(dotWidth: 15, dotHeight: 2, dotCornerRadius: 1.0, dotColor: UIColor(white: 1.0, alpha: 0.4), dotSelectColor: UIColor(white: 1.0, alpha: 0.8))
        layout.dotMargin = 10.0
        
        autoScrollView.dotLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
}
