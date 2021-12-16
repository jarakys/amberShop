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
    
    let imgs: [UIImage] = [UIImage(named: "image-visa")!, UIImage(named: "image-mastercard")!, UIImage(named: "image-fondy")!]
    
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
    
    override func configureLeftBar() {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        backBtn.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        
        let logoBtn: UIButton = UIButton()
        logoBtn.setImage(UIImage(named: "logo".localized), for: .normal)
        logoBtn.setImage(UIImage(named: "logo".localized), for: .highlighted)
        logoBtn.setImage(UIImage(named: "logo".localized), for: .selected)
        logoBtn.isEnabled = false
        logoBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        logoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 100)
        let logoBarBtn = UIBarButtonItem(customView: logoBtn)

        self.navigationItem.setLeftBarButtonItems([backBarBtn, logoBarBtn], animated: false)
    }
    
    override func closeButtonDidClick() {
        navigationController?.popViewController(animated: true)
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
        if indexPath.section == 0 {
            cell.setTitle(text: "delivery_title3")
            cell.setText(text: "delivery_info3")
        } else if indexPath.section == 1 {
            cell.setTitle(text: "delivery_title2")
            cell.setText(text: "delivery_info2")
        } else {
            cell.setTitle(text: "delivery_title1")
            cell.setText(text: "delivery_info1")
        }
        if indexPath.section == 1 {
            cell.setImage(img: UIImage(named: "image-novaposhta")!)
        } else if indexPath.section == 2 {
            cell.setImages(imgs: imgs)
            return cell
        }
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
