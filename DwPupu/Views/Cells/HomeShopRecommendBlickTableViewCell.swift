//
//  HomeShopRecommendBlickTableViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/19.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit
import SnapKit

class HomeShopRecommendBlickTableViewCell: UITableViewCell, DwCellHeightProtocol {
    static let cellHeight: CGFloat = 270.0
    
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private let containerPadding:CGFloat = 15.0
    private let pagePadding:CGFloat = 8.0
    private let itemPadding:CGFloat = 4.0
    private let heightWidthDiv = CGFloat(260.0/384.0)
    private let pageMarginTop:CGFloat = 36.0
    private let itemMarginBottom:CGFloat = 20.0
    
    func setup(homeItem: HomeItem) {
        self.containerView.subviews.forEach { subView in
            if subView.isKind(of: LTAutoScrollView.self) {
                subView.removeFromSuperview()
            }
        }
        let width = DwScreen.width - containerPadding*2
        let height = heightWidthDiv * width
        
        let autoScrollView = LTAutoScrollView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        self.containerView.addSubview(autoScrollView)
        
        // 他内部的CollectionView和PageControl是在初始化的时候去初始frame的
        // 而当时并没有autolayout，所以如果不设置frame，而是用autolayout的话，会导致初始化的CollectionView和PageControl都frame不正确
//        autoScrollView.snp.makeConstraints { make in
//            make.top.left.bottom.right.equalToSuperview()
//        }
        
        
        let pageViewHeight = height - pageMarginTop
        let itemViewWidth = (width-pagePadding*2-itemPadding*2)/3
        let itemViewHeight = pageViewHeight - itemMarginBottom
        
        autoScrollView.isAutoScroll = false
        autoScrollView.backgroundColorIsClear = true
        
        autoScrollView.autoViewHandle = {[weak self] in
            var results:[UIView] = []
            guard let self = self else {
                return results
            }
            for i in 0..<5 {
                let view = UIView(frame: CGRect(x: 0, y: self.pageMarginTop, width: width, height: pageViewHeight))
                results.append(view)
                view.backgroundColor = UIColor.clear
                var offsetX = self.pagePadding
                for j in Array(0..<3) {
                    let subItemIndex = i*3 + j
                    if (subItemIndex >= homeItem.items.count) { continue }
                    let homeSubItem = homeItem.items[subItemIndex]
                    
                    let itemView = UIView(frame: CGRect(x: offsetX, y: 0.0, width: itemViewWidth, height: itemViewHeight))
                    itemView.backgroundColor = UIColor.white
                    itemView.layer.cornerRadius = 6.0
                    view.addSubview(itemView)
                    
                    var offsetY:CGFloat = 0
                    
                    let topView = UIView(frame: CGRect(x: 0, y: offsetY, width: itemViewWidth, height: itemViewWidth))
                    offsetY += itemViewWidth
                    itemView.addSubview(topView)
                    let topImageView = UIImageView(frame: topView.bounds)
                    topImageView.contentMode = UIView.ContentMode.scaleAspectFit
                    topImageView.kf.setImage(with: URL(string: "https://imgs.static.pupumall.com/\(homeSubItem.imgUrl)"))
                    topView.addSubview(topImageView)
                    let titleLabel = UILabel(frame: CGRect(x: 0, y: offsetY, width: itemViewWidth, height: 17))
                    offsetY += 17.0
                    titleLabel.textAlignment = .center
                    titleLabel.text = homeSubItem.name
                    titleLabel.font = UIFont.systemFont(ofSize: 12)
                    titleLabel.textColor = UIColor(hex: "#333333")
                    itemView.addSubview(titleLabel)
                    titleLabel.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                        make.height.equalTo(17)
                        make.top.equalTo(topView.snp.bottom)
                    }
                    
                    let priceContainerView = UIView(frame: CGRect(x: 0, y: offsetY, width: itemViewWidth, height: 23.0))
                    offsetY += 23.0
                    itemView.addSubview(priceContainerView)
                    
                    let labelContainerView = UIView()
                    priceContainerView.addSubview(labelContainerView)
                    labelContainerView.snp.makeConstraints { make in
                        make.height.equalTo(23)
                        make.center.equalToSuperview()
                    }
                    
                    let saleColor = UIColor(hex: "#FF9000")
                    let priceColor = UIColor(hex: "#DDDDDD")
                    let saleUnitLabel = UILabel()
                    saleUnitLabel.text = "￥"
                    let unitLabel = UILabel()
                    unitLabel.text = "￥"
                    let salePriceLabel = UILabel()
                    let priceLabel = UILabel()
                    salePriceLabel.text = "\(Float(homeSubItem.price/100))"
                    priceLabel.text = "\(Float(homeSubItem.marketPrice/100))"
                    let crossedLineView = UIView()
                    salePriceLabel.textColor = saleColor
                    saleUnitLabel.textColor = saleColor
                    priceLabel.textColor = priceColor
                    unitLabel.textColor = priceColor
                    
                    salePriceLabel.font = UIFont.systemFont(ofSize: 15)
                    saleUnitLabel.font = UIFont.systemFont(ofSize: 15)
                    priceLabel.font = salePriceLabel.font
                    unitLabel.font = salePriceLabel.font
                    crossedLineView.backgroundColor = priceColor
                    labelContainerView.addSubview(salePriceLabel)
                    labelContainerView.addSubview(saleUnitLabel)
                    labelContainerView.addSubview(priceLabel)
                    labelContainerView.addSubview(unitLabel)
                    labelContainerView.addSubview(crossedLineView)
                    saleUnitLabel.snp.makeConstraints { make in
                        make.left.bottom.equalToSuperview()
                    }
                    salePriceLabel.snp.makeConstraints { make in
                        make.bottom.equalToSuperview()
                        make.left.equalTo(saleUnitLabel.snp.right)
                    }
                    unitLabel.snp.makeConstraints { make in
                        make.bottom.equalToSuperview()
                        make.left.equalTo(salePriceLabel.snp.right).offset(3)
                    }
                    priceLabel.snp.makeConstraints { make in
                        make.bottom.right.equalToSuperview()
                        make.left.equalTo(unitLabel.snp.right)
                    }
                    crossedLineView.snp.makeConstraints { make in
                        make.height.equalTo(1)
                        make.left.equalTo(unitLabel.snp.left)
                        make.right.equalTo(priceLabel.snp.right)
                        make.centerY.equalTo(unitLabel.snp.centerY)
                    }
                    
                    let btnView = UIView(frame: CGRect(x: 0, y: offsetY, width: itemViewWidth, height: itemViewHeight - offsetY))
                    itemView.addSubview(btnView)
                    
                    let shopCarBtn = UIButton()
                    
                    btnView.addSubview(shopCarBtn)
                    shopCarBtn.snp.makeConstraints { make in
                        make.height.equalTo(22)
                        make.width.equalTo(70)
                        make.center.equalToSuperview()
                    }
                    shopCarBtn.setTitle("加入购物车", for: .normal)
                    shopCarBtn.backgroundColor = UIColor(hex: "#17B356")
                    shopCarBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
                    shopCarBtn.layer.cornerRadius = 13
                    shopCarBtn.layer.shadowColor = shopCarBtn.backgroundColor?.cgColor
                    shopCarBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
                    shopCarBtn.layer.shadowRadius = 2
                    shopCarBtn.layer.shadowOpacity = 0.3
                    
                    offsetX += itemViewWidth + self.itemPadding
                }
            }
            return results
        }
        autoScrollView.scrollDirection = .horizontal
        autoScrollView.gltPageControlHeight = 16

        //设置LTDotLayout，更多dot使用见LTDotLayout属性说明
        let layout = LTDotLayout(dotWidth: 15, dotHeight: 2, dotCornerRadius: 1.0, dotColor: UIColor(white: 1.0, alpha: 0.4), dotSelectColor: UIColor(white: 1.0, alpha: 0.8))
        layout.dotMargin = 10.0
        
        autoScrollView.dotLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
}
