//
//  AboutUsViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 26.11.2021.
//

import UIKit

class DeliveryInfoViewController: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    
    private var deliveryInfo: DeliveryInfoModel? {
        didSet {
            contentTableView.reloadData()
        }
    }
    
    let imgs: [UIImage] = [UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!, UIImage(named: "logo.icon")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "DeliveryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryInfoTableViewCell")
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = .white
        contentTableView.allowsSelection = false
        
        StoreManager.shared.getDeliveryInfo(completion: {[weak self] deliveryInfo, error in
            guard let deliveryInfo = deliveryInfo else { return }
            self?.deliveryInfo = deliveryInfo
        })
    }

}

extension DeliveryInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deliveryInfo == nil ? 0 : 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        deliveryInfo == nil ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoTableViewCell", for: indexPath) as! DeliveryInfoTableViewCell
        if indexPath.section == 0 {
            cell.setText(text: deliveryInfo?.del1 ?? "")
        } else if indexPath.section == 1 {
            cell.setText(text: deliveryInfo?.del2 ?? "")
        } else {
            cell.setText(text: deliveryInfo?.del3 ?? "")
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            20
    }
    
}
