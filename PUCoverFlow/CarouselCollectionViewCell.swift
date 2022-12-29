//
//  CarouselCollectionViewCell.swift
//  Created by Payal Umraliya on 29/12/22.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var heightStacklabels: NSLayoutConstraint!
    @IBOutlet weak var vwmain: UIView!
    @IBOutlet weak var lbltag: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lbldescr: UILabel!
    @IBOutlet weak var imgshadow: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var stacklabels: UIStackView!
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.contentView.layer.masksToBounds = true
//        self.layer.cornerRadius = 10 //max(self.frame.size.width, self.frame.size.height) / 2
//        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
    }
}
