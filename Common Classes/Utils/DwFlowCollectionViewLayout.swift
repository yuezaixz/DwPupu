//
//  DwFlowCollectionViewLayout.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/21.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

protocol DwFlowCollectionViewLayoutDelegate: AnyObject {
    func waterFallLayout(_ waterFallLayout: DwFlowCollectionViewLayout, heightForItemAtIndexPath indexPath: Int) -> CGFloat
    
    func isFullRowInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout, inIndexPath indexPath: Int) -> Bool
    
    func columnCountInWaterFallLayout(_ waterFallLayout: DwFlowCollectionViewLayout) -> Int?
    
    func columnMarginInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout) -> CGFloat?
    
    func rowMarginInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout) -> CGFloat?
    
    func edgeInsetdInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout) -> UIEdgeInsets?
}

extension DwFlowCollectionViewLayoutDelegate {
    func columnCountInWaterFallLayout(_ waterFallLayout: DwFlowCollectionViewLayout) -> Int? { return nil }
    
    func columnMarginInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout) -> CGFloat? { return nil }
    
    func rowMarginInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout) -> CGFloat? { return nil }
    
    func edgeInsetdInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout) -> UIEdgeInsets? { return nil }
    
    func isFullRowInWaterFallLayout(_ columnCountInWaterFallLayout: DwFlowCollectionViewLayout, inIndexPath indexPath: Int) -> Bool {
        return false
    }
}

class DwFlowCollectionViewLayout: UICollectionViewFlowLayout {
    weak var delegate:DwFlowCollectionViewLayoutDelegate?
    
    /** 默认列数 */
    private(set) var kItemHeightDefault : CGFloat = 50
    /** 默认列数 */
    private(set) var kColumnCountDefault : Int = 2
   /** 每一列之间的间距 垂直 */
    private(set) var kColumnMarginDefault : CGFloat = 10.0
   /** 每一行之间的间距 水平方向 */
    private(set) var kRowMarginDefault : CGFloat = 10.0
   /** 边缘间距 */
    private(set) var kEdgeInsetsDefault : UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    //懒加载
    //存放所有cell的布局属性
    lazy var attrsArray = [UICollectionViewLayoutAttributes]()
    //存放所有列的当前高度
    lazy var columnHeights = [CGFloat]()
    
    private var colunmCount:Int {
        return delegate?.columnCountInWaterFallLayout(self) ?? kColumnCountDefault
    }
    
    private var columnMargin:CGFloat {
        return delegate?.columnMarginInWaterFallLayout(self) ?? kColumnMarginDefault
    }
    
    private var rowMargin:CGFloat {
        return delegate?.rowMarginInWaterFallLayout(self) ?? kRowMarginDefault
    }
    
    private var edgeInsets:UIEdgeInsets {
        return delegate?.edgeInsetdInWaterFallLayout(self) ?? kEdgeInsetsDefault
    }
    
    override func prepare() {
        super.prepare()
        //清除高度
        columnHeights.removeAll()
        
        for _ in 0 ..< self.colunmCount {
            columnHeights.append(self.edgeInsets.top)
        }
        
        //清除所有的布局属性
        attrsArray.removeAll()
        
        let sections : Int = (self.collectionView?.numberOfSections)!
        
        for num in 0 ..< sections {
            let count : Int = (self.collectionView?.numberOfItems(inSection: num))!//获取分区0有多少个item
            for i in 0 ..< count {
                let indexpath : NSIndexPath = NSIndexPath.init(item: i, section: num)
                let attrs = self.layoutAttributesForItem(at: indexpath as IndexPath)!
                
                attrsArray.append(attrs)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let collectionWidth = self.collectionView?.frame.size.width
        
        //获得所有item的宽度
        let __W = (collectionWidth! - self.edgeInsets.left - self.edgeInsets.right - CGFloat(self.colunmCount-1) * self.columnMargin) / CGFloat(self.colunmCount)
        let __H = delegate?.waterFallLayout(self, heightForItemAtIndexPath: indexPath.row) ?? kItemHeightDefault
        
        
        if delegate?.isFullRowInWaterFallLayout(self, inIndexPath: indexPath.row) ?? false {
            let y = columnHeights.reduce(0) { (result, current) -> CGFloat in
                return max(result, current)
            }
            let x = self.edgeInsets.left
            attrs.frame = CGRect(x: x, y: y, width: __W * CGFloat(self.colunmCount), height: CGFloat(__H))
            //更新所有列
            columnHeights.removeAll()
            
            for _ in 0 ..< self.colunmCount {
                columnHeights.append(attrs.frame.maxY)
            }
        } else {
            //找出高度最短那一列
            var dextColum : Int = 0
            var mainH = columnHeights[0]
            
            for i in 1 ..< self.colunmCount{
                //取出第i列的高度
                let columnH = columnHeights[i]
                
                if mainH > columnH {
                    mainH = columnH
                    dextColum = i
                }
            }

            var y = mainH
            if y != self.edgeInsets.top{
                y = y + self.rowMargin
            }
            let x = self.edgeInsets.left + CGFloat(dextColum) * (__W + self.columnMargin)
            
            attrs.frame = CGRect(x: x, y: y, width: __W, height: CGFloat(__H))
            //更新最短那列高度
            columnHeights[dextColum] = attrs.frame.maxY
        }
        
        
        return attrs
    }
    
    override var collectionViewContentSize: CGSize {
        
        var maxHeight = columnHeights[0]
        
        for i in 1 ..< self.colunmCount {
            let columnHeight = columnHeights[i]
            
            if maxHeight < columnHeight {
                maxHeight = columnHeight
            }
        }
        
        return CGSize.init(width: 0, height: maxHeight + self.edgeInsets.bottom)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
    }
}
