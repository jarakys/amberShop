//
//  CatalogViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 22.11.2021.
//

import UIKit

class CatalogViewController: BaseViewController {

    @IBOutlet weak var catalogTableView: UITableView!
    @IBOutlet weak var ruButton: UIButton!
    @IBOutlet weak var uaBtton: UIButton!
    
    private lazy var viewModel: MenuViewModel = {
        MenuViewModel()
    }()
    
    public var separateNaviationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
        catalogTableView.separatorStyle = .none
        catalogTableView.register(UINib(nibName: "ContactInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactInformationTableViewCell")
        catalogTableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        configureLeftBar()

        viewModel.$nodes.sink(receiveValue: {[weak self] _ in
            DispatchQueue.main.async {
                self?.catalogTableView.reloadData()
            }
        }).store(in: &cancellable)
        
        viewModel.$error.sink(receiveValue: {[weak self] error in
            guard let error = error else { return }
            let alert = UIAlertController(title: "error".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(.init(title: "retry".localized, style: .default, handler: {_ in
                self?.viewModel.loadData()
            }))
            alert.addAction(.init(title: "cancel".localized, style: .default, handler: {_ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true, completion: nil)
        }).store(in: &cancellable)
        
        viewModel.$inProgress.sink(receiveValue: {[weak self] inProgress in
            inProgress ? self?.view.showBlurLoader() : self?.view.removeBluerLoader()
        }).store(in: &cancellable)
        viewModel.loadData()
        ruButton.addTarget(self, action: #selector(ruDidClick(_:)), for: .touchUpInside)
        uaBtton.addTarget(self, action: #selector(uaDidClick(_:)), for: .touchUpInside)
    }
    
    override func configureRightBar() {
        let cartBtn: UIButton = UIButton()
        cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
        cartBtn.addTarget(self, action: #selector(cartButtonDidClick), for: .touchUpInside)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        cartBtn.tintColor = .white
        cartBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        cartBtn.layer.cornerRadius = 13
        
        let countLabel = UILabel(frame: CGRect(x: cartBtn.frame.width + 10, y: -10, width: 40, height: 30))
        countLabel.text = ""
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 10, weight: .bold)
        cartBtn.addSubview(countLabel)
        countLabel.textAlignment = .center
        countLabel.frame = CGRect(x: 0, y: -8, width: 35, height: 30)
        
        if let basketItems: [BasketWrapItem] = LocalStorageManager.shared.get(key: .savedProducts),
           !basketItems.isEmpty {
            let count = basketItems.reduce(0, {result, item in
                return result + item.basketModel.quantity
            })
            countLabel.text = count.description
        }
        
        let cartBarBtn = UIBarButtonItem(customView: cartBtn)


        let closeBtn: UIButton = UIButton()
        closeBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        closeBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        closeBtn.tintColor = .white
        closeBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        closeBtn.layer.cornerRadius = 13
        let closeBarBtn = UIBarButtonItem(customView: closeBtn)
        
        self.navigationItem.setRightBarButtonItems([closeBarBtn, cartBarBtn], animated: false)
    }
    
    @objc private func ruDidClick(_ sender: UIButton) {
        LocalStorageManager.shared.set(key: .localization, value: "ru")
        StoreManager.shared.initStore()
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage("ru")
        viewModel.loadData()
    }
    
    @objc private func uaDidClick(_ sender: UIButton) {
        LocalStorageManager.shared.set(key: .localization, value: "ua")
        StoreManager.shared.initStore()
        UserDefaults.standard.set(["uk"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage("uk")
        viewModel.loadData()
    }
    
    override func cartButtonDidClick() {
        guard let basketData: [BasketWrapItem] = LocalStorageManager.shared.get(key: .savedProducts),
        !basketData.isEmpty else {
            showAlert(message: "basket_is_empty".localized, title: "", action: nil)
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Cart") as! CartViewController
        separateNaviationController?.pushViewController(vc, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func contactsDidClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Contacts") as! ContactsViewController
        separateNaviationController?.popToRootViewController(animated: false)
        separateNaviationController?.pushViewController(vc, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func deliveryDidClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeliveryInfo") as! DeliveryInfoViewController
        separateNaviationController?.popToRootViewController(animated: false)
        separateNaviationController?.pushViewController(vc, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func aboutUsDidClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
        separateNaviationController?.popToRootViewController(animated: false)
        separateNaviationController?.pushViewController(vc, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(text: String) {
        titleLabel.text = text
        titleLabel.font = UIFont(name: "Oswald-Regular", size: 17)!
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 1
        }
        return viewModel.nodes[section].menuItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectionCell
        if !viewModel.nodes[indexPath.section].menuItems.isEmpty {
            let category = viewModel.nodes[indexPath.section].menuItems[indexPath.row]
            cell.setTitle(text: category.name)
        }
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInformationTableViewCell", for: indexPath) as! ContactInformationTableViewCell
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView(frame: CGRect(x: 50, y: 0, width: tableView.frame.size.width, height: 30))
        sectionView.backgroundColor = .white
        sectionView.tintColor = .black
        
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        sectionLabel.text = viewModel.nodes[section].name
        sectionLabel.font = UIFont(name: "Oswald-SemiBold", size: 20)!
        sectionLabel.textAlignment = .left
        
        sectionView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstr = sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor)
        let leftConstr = sectionLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 20)
        sectionView.addConstraints([horizontalConstr, leftConstr])
        
        if section == 1 {
            let sectionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let attributedString = NSAttributedString(string: viewModel.nodes[section].name, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black,
//                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
                NSAttributedString.Key.font : UIFont(name: "Oswald-SemiBold", size: 20)!
                ])

            sectionButton.setAttributedTitle(attributedString, for: .normal)
            sectionButton.addTarget(self, action: #selector(aboutUsDidClick), for: .touchUpInside)
            sectionButton.contentHorizontalAlignment = .left
            sectionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return sectionButton
        }
        
        if section == 2 {
            let sectionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let attributedString = NSAttributedString(string: viewModel.nodes[section].name, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black,
//                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
                NSAttributedString.Key.font : UIFont(name: "Oswald-SemiBold", size: 20)!
                ])

            sectionButton.setAttributedTitle(attributedString, for: .normal)
            sectionButton.addTarget(self, action: #selector(deliveryDidClick), for: .touchUpInside)
            sectionButton.contentHorizontalAlignment = .left
            sectionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return sectionButton
        }
        
        if section == 3 {
            let sectionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let attributedString = NSAttributedString(string: viewModel.nodes[section].name, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black,
//                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
                NSAttributedString.Key.font : UIFont(name: "Oswald-SemiBold", size: 20)!
                ])

            sectionButton.setAttributedTitle(attributedString, for: .normal)
            sectionButton.addTarget(self, action: #selector(contactsDidClick), for: .touchUpInside)
            sectionButton.contentHorizontalAlignment = .left
            sectionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return sectionButton
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let separateNaviationController = separateNaviationController else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Products") as! ProductsViewController
            let category = viewModel.nodes[indexPath.section].menuItems[indexPath.row]
            vc.category = CategoryModel(category_id: category.subcategory_id, name: category.name, image: nil)
            separateNaviationController.popToRootViewController(animated: false)
            separateNaviationController.pushViewController(vc, animated: false)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
