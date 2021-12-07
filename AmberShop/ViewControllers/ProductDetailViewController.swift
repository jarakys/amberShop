//
//  ProductDetailViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class ProductDetailViewController: BaseViewController {
    
    public var viewModel: ProductDetailViewModel?

    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNotification()
        contentTableView.separatorStyle = .none
        contentTableView.allowsSelection = false
        contentTableView.delegate = self
        contentTableView.dataSource = self
        configure()
        contentTableView.register(UINib(nibName: "ProductSettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductSettingsTableViewCell")
        contentTableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        contentTableView.register(UINib(nibName: "TextDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "TextDescriptionTableViewCell")
        contentTableView.register(UINib(nibName: "TableSizesTableViewCell", bundle: nil), forCellReuseIdentifier: "TableSizesTableViewCell")
        contentTableView.register(UINib(nibName: "DeliveryInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryInfoTableViewCell")
        contentTableView.register(UINib(nibName: "ProductSpecificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductSpecificationsTableViewCell")
    }
    
    func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizationChange(_:)), name: Notification.Name("LocalizationChanged"), object: nil)
    }
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.$productItemDetails.sink(receiveValue: {[weak self] _ in
            DispatchQueue.main.async {
                self?.contentTableView.reloadData()
            }
        }).store(in: &cancellable)
        
        viewModel.$error.sink(receiveValue: {[weak self] error in
            guard let error = error else { return }
            let alert = UIAlertController(title: "error".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(.init(title: "retry".localized, style: .default, handler: {_ in
                self?.viewModel?.loadData()
            }))
            alert.addAction(.init(title: "cancel".localized, style: .default, handler: {_ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true, completion: nil)
        }).store(in: &cancellable)
        
        viewModel.$inProgress.sink(receiveValue: {[weak self] inProgress in
            guard inProgress else {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                    self?.view.removeBluerLoader()
                })
                return
            }
            self?.view.showBlurLoader()
        }).store(in: &cancellable)
        contentTableView.reloadData()
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
    
    private func addToBasket(state: ProductSettingsModel) {
        guard let model = viewModel?.productItemDetails else {
            return
        }
        
        let basketWrapItem = BasketWrapItem(product: model, basketModel: BasketItem(product_id: Int(model.id) ?? 1, name: model.name, quantity: Int(state.count.value ?? "1") ?? 1, model: model.name, options: [state.color, state.size], price: model.price))
        
        LocalStorageManager.shared.add(key: .savedProducts, value: basketWrapItem)
        
        showAlert(message: "t_shirt_added_to_cart".localized, title: "success".localized, action: nil)
        
    }
    
    @objc func localizationChange(_ notification: Notification) {
        viewModel?.loadData()
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.productItemDetails == nil ? 0 : 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.iconImageView.loadImage(imageURL: viewModel?.productItemDetails?.add_photo1 ?? "")
            cell.titleLabel.attributedText = viewModel?.productItemDetails?.name.getHTMLText(with: cell.titleLabel.font)
            cell.subtitleLabel.attributedText = viewModel?.productItemDetails?.model.getHTMLText(with: cell.subtitleLabel.font)
            cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            cell.layer.shadowOpacity = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 16
            
            return cell
            
        } else  if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSettingsTableViewCell", for: indexPath) as! ProductSettingsTableViewCell
            if let model = viewModel?.productItemDetails {
                cell.configure(for: model)
            }
            
            cell.errorOccurred = {[weak self] in
                let alert = UIAlertController(title: "error".localized, message: "field_validation_error".localized, preferredStyle: .alert)
                alert.addAction(.init(title: "ok".localized, style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
            
            cell.toBasketClick = {[weak self] state in
                self?.addToBasket(state: state)
            }
            cell.setSalePrice(text: (viewModel?.productItemDetails?.formatedPrice.description ?? "") + " грн")
            return cell
            
        } else if indexPath.section == 2 {
            let description = viewModel?.productItemDetails?.description.replacingOccurrences(of: "/<img[^>]*>/g", with: "", options: String.CompareOptions.regularExpression, range: nil)
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextDescriptionTableViewCell", for: indexPath) as! TextDescriptionTableViewCell
            cell.contentLabel.attributedText = description?.getHTMLText(with: cell.contentLabel.font)
            return cell
            
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryInfoTableViewCell", for: indexPath) as! DeliveryInfoTableViewCell
            cell.setTitle(text: "payment_and_delivery")
            cell.setImages(imgs: [UIImage(named: "image-visa")!, UIImage(named: "image-mastercard")!, UIImage(named: "image-fondy")!, UIImage(named: "image-novaposhta")!])
            cell.contentTextView.text = nil
            cell.contentTextView.sizeToFit()
            cell.backgroundColor = .clear
            return cell
            
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSpecificationsTableViewCell", for: indexPath) as! ProductSpecificationsTableViewCell
            if let model = viewModel?.productItemDetails {
                cell.configure(for: model, branchName: viewModel?.branchName ?? "")
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableSizesTableViewCell", for: indexPath) as! TableSizesTableViewCell
            if let model = viewModel?.productItemDetails {
                cell.configure(for: model)
            }
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
