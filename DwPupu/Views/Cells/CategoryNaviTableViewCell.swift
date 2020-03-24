//
//  CategoryNaviTableViewCell.swift
//  DwPupu
//
//  Created by 吴迪玮 on 2020/3/22.
//  Copyright © 2020 davidandty. All rights reserved.
//

import UIKit

class CategoryNaviTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with model: Category) {
        self.nameLabel.text = model.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedView.backgroundColor = (selected == true ? UIColor(hex: "#17B356"):UIColor.white)
        nameLabel.textColor = (selected == true ? UIColor(hex: "#17B356"):UIColor(hex: "#333333"))
        nameLabel.backgroundColor = (selected == true ? UIColor.white: UIColor(hex: "#FAFAFA"))
    }
    
}
