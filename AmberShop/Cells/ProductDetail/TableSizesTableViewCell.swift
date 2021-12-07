//
//  TableSizesTableViewCell.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class TableSizesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sizesImageView: UIImageView!
    @IBOutlet weak var tshirtMetricsImageView: UIImageView!
    @IBOutlet var imageScrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.localizationKey = "table_sizes"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(for model: ProductDetailModel) {
        guard let tableUrl = model.table else {
            return
        }
        sizesImageView.loadImage(imageURL: tableUrl, completionHandler: {[weak self] in
            guard let self = self else { return }
//            self.imageScrollView.contentSize = self.sizesImageView.frame.size
        })
    }
    
}
