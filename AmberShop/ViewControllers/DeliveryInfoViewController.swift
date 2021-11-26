//
//  AboutUsViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 26.11.2021.
//

import UIKit

class DeliveryInfoViewController: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    
    let imgs: [UIImage] = [UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "DeliveryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryInfoTableViewCell")
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = .white
        contentTableView.allowsSelection = false
        
    }

}

extension DeliveryInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoTableViewCell", for: indexPath) as! DeliveryInfoTableViewCell
        if indexPath.section == 2 {
            cell.setImages(imgs: imgs)
            return cell
        }
        cell.setImage(img: UIImage(named: "logo.icon")!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let heaserView = UIView()
        heaserView.backgroundColor = .clear
    
        return heaserView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            20
    }
    
}
