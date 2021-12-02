//
//  ProductDetailViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class ProductDetailViewController: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.separatorStyle = .none
        contentTableView.allowsSelection = false
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "ProductSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductSettingsTableViewCell")
        contentTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        contentTableView.register(UINib(nibName: "TextDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "TextDescriptionTableViewCell")
        contentTableView.register(UINib(nibName: "TableSizesTableViewCell", bundle: nil), forCellReuseIdentifier: "TableSizesTableViewCell")
        contentTableView.register(UINib(nibName: "DeliveryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryInfoTableViewCell")
        contentTableView.register(UINib(nibName: "ProductSpecificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductSpecificationsTableViewCell")
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.iconImageView.image = UIImage(named: "testImg")
            cell.titleLabel.text = "Оригинальная мужская футболка Fruit of thr Loom"
            cell.subtitleLabel.text = "Модель ValueWeight 610360"
        return cell
            
        } else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSettingsTableViewCell", for: indexPath) as! ProductSettingsTableViewCell
            cell.setOldPrice(text: "300 грн")
            cell.setSalePrice(text: "800 грн")
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextDescriptionTableViewCell", for: indexPath) as! TextDescriptionTableViewCell
            cell.contentLabel.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
            return cell
            
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoTableViewCell", for: indexPath) as! DeliveryInfoTableViewCell
            cell.titleLabel.text = "Оплата и доставка"
            cell.setImage(img: UIImage(named: "logo.icon")!)
            cell.contentTextView.text = nil
            cell.backgroundColor = .clear
            return cell
            
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSpecificationsTableViewCell", for: indexPath) as! ProductSpecificationsTableViewCell
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableSizesTableViewCell", for: indexPath) as! TableSizesTableViewCell
            cell.titleLabel.text = "Таблица размеров в сантиметрах:"
            cell.sizesImageView.image = UIImage(named: "size_table")
            cell.tshirtMetricsImageView.image = UIImage(named: "tshirt")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 50, y: 0, width: tableView.frame.size.width, height: 20))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
