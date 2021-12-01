//
//  CartViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class CartViewController: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    let sectionTitels = ["your_basket".localized, "fill_out_the_application_form".localized]
    
    var products: [ProductItemModel] {
        LocalStorageManager.shared.get(key: .savedProducts) ?? []
    }
    
    var productsIdentity: [String: [ProductItemModel]] {
        Dictionary(grouping: products, by: { $0.id })
    }
    
    var productModels: [ProductModel] {
        var models = [ProductModel]()
        productsIdentity.forEach({ item in
            models.append(ProductModel(product_id: Int(item.key) ?? 1, name: item.value.first?.name ?? "", quantity: item.value.count, model: item.value.first?.name ?? "", options: []))
        })
        return models
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.separatorStyle = .none
        contentTableView.allowsSelection = false
        contentTableView.register(UINib(nibName: "OrderFormTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFormTableViewCell")
        contentTableView.register(UINib(nibName: "DeliveryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryInfoTableViewCell")
        contentTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
    }
    
    private func calculateTotalPrice() -> Double {
        return products.reduce(0, { result, nextItem in
            (Double(nextItem.price) ?? 0) + result
        })
    }
    private func makeOrder(userDataModel: UserDataModel) {
        let orderRequestModel = OrderRequestModel(shipping_value: calculateTotalPrice(), comment: userDataModel.comment, products: productModels, email: userDataModel.email, telephone: userDataModel.telephone, firstname: userDataModel.firstname, lastname: userDataModel.lastname, address: userDataModel.address, number: userDataModel.number)
        NetworkManager.shared.sendRequest(route: .sendOrder(orderRequestModel: orderRequestModel), completion: {response in
            switch response {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(String(data: data, encoding: .utf8))
            }
        })
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.configure(for: products)
            cell.sizeChanged = {[weak tableView] in
                tableView?.reloadData()
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFormTableViewCell", for: indexPath) as! OrderFormTableViewCell
            cell.checkoutOrderClick = {[weak self] error, userDataModel in
                guard let userDataModel = userDataModel else {
                    return
                }
                self?.makeOrder(userDataModel: userDataModel)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoTableViewCell", for: indexPath) as! DeliveryInfoTableViewCell
            cell.setImage(img: UIImage(named: "logo.icon")!)
            cell.backgroundColor = .white
            cell.setTitle(text: "payment_and_delivery".localized)
            cell.contentTextView.backgroundColor = .white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 50, y: 0, width: tableView.frame.size.width, height: 30))
        sectionView.backgroundColor = .white
        sectionView.tintColor = .black
        
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        if section < sectionTitels.count {
            sectionLabel.text = sectionTitels[section]
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 18)
            sectionLabel.textAlignment = .left
        }
    
        sectionView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstr = sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor)
        let leftConstr = sectionLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 20)
        sectionView.addConstraints([horizontalConstr, leftConstr])
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
}
