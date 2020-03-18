//
//  HomeMenuCollectionViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/18.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

class HomeMenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        self.normalizeCell()
        self.titleLabel.text = ""
        self.subTitleLabel.text = ""
    }
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                self.highlightCell()
            } else {
                self.normalizeCell()
            }
        }
    }
    
    private func highlightCell() {
        titleLabel.textColor = UIColor(hex: "#17B356")
        subTitleLabel.textColor = UIColor.white
        subTitleLabel.backgroundColor = UIColor(hex: "#17B356")
    }
    
    private func normalizeCell() {
        titleLabel.textColor = UIColor(hex: "#333333")
        subTitleLabel.textColor = UIColor(hex: "#BBBBBB")
        subTitleLabel.backgroundColor = UIColor.white
    }

}
