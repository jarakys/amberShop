//
//  CartViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 28.11.2021.
//

import UIKit

class CartViewController: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    let sectionTitels = ["your_basket", "fill_out_the_application_form"]
    
    var products: [BasketWrapItem] {
        LocalStorageManager.shared.get(key: .savedProducts) ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.separatorStyle = .none
        contentTableView.allowsSelection = false
        contentTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        contentTableView.register(UINib(nibName: "OrderFormTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderFormTableViewCell")
        contentTableView.register(UINib(nibName: "DeliveryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryInfoTableViewCell")
        contentTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
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
        logoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        let logoBarBtn = UIBarButtonItem(customView: logoBtn)

        self.navigationItem.setLeftBarButtonItems([backBarBtn, logoBarBtn], animated: false)
    }
    
    override func closeButtonDidClick() {
        navigationController?.popViewController(animated: true)
    }
    
    override func configureRightBar() {
    }
    
    private func makeOrder(userDataModel: UserDataModel) {
        guard let basketWrapped: [BasketWrapItem] = LocalStorageManager.shared.get(key: .savedProducts) else { return }
        let basketItems = basketWrapped.map({ $0.basketModel })
        userDataModel.products = basketItems
        NetworkManager.shared.sendRequest(route: .sendOrder(orderRequestModel: userDataModel), completion: {[weak self] response in
            switch response {
            case .failure(let error):
                self?.showAlert(message: "server_error".localized)
            case .success(let data):
                self?.openPaymentScreen(userDataModel: userDataModel, paymentCompletion: { success in
                    guard success else {
                        self?.showAlert(message: "product_not_payed".localized)
                        return
                    }
                    self?.showAlert(message: "order_accept".localized, title: "success".localized, action: {
                        self?.navigationController?.popViewController(animated: true)
                        LocalStorageManager.shared.clear(key: .savedProducts)
                    })
                })
                
            }
        })
    }
    
    public func openPaymentScreen(userDataModel: UserDataModel, paymentCompletion: ((Bool) -> Void)?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        let price = userDataModel.products.reduce(0.0, { result, item in
            return result + (Double(item.quantity) * (Double(item.price) ?? 0.0))
        })
        vc.completion = paymentCompletion
        vc.viewModel = PaymentViewModel(customerEmail: userDataModel.email, sum: price)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public override func showAlert(message: String, title: String = "error", action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "ok".localized, style: .default, handler: {_ in
            action?()
        }))
        self.present(alert, animated: true, completion: nil)
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
            cell.itemDeletedAction = {[weak self] in
                if self?.products.isEmpty == true {
                    self?.showAlert(message: "basket_is_empty".localized, action: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderFormTableViewCell", for: indexPath) as! OrderFormTableViewCell
            cell.checkoutOrderClick = {[weak self] error, userDataModel in
                guard let userDataModel = userDataModel else {
                    return
                }
                if error == .agreement {
                    self?.showAlert(message: "accept_agreement".localized)
                    return
                }
                self?.makeOrder(userDataModel: userDataModel)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoTableViewCell", for: indexPath) as! DeliveryInfoTableViewCell
            cell.setImages(imgs: [UIImage(named: "image-visa")!, UIImage(named: "image-mastercard")!, UIImage(named: "image-fondy")!, UIImage(named: "image-novaposhta")!])
            cell.backgroundColor = .white
            cell.setTitle(text: "payment_and_delivery")
            cell.contentTextView.backgroundColor = .white
            cell.setText(text: "payment_and_delivery_desc")
            cell.contentTextView.sizeToFit()
            cell.setLeftTopConstraint(constatnt: 16)
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
            sectionLabel.localizationKey = sectionTitels[section]
            sectionLabel.font = UIFont(name: "Oswald-SemiBold", size: 18)
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
