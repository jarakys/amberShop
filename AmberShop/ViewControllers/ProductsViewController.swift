//
//  ProductsViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 23.11.2021.
//

import UIKit
import Presentr

class ProductsViewController: BaseViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    
    public var category: CategoryModel?
    var categoryName: String {
        (category?.name ?? "").localized
    }
    let headerLabel = UILabel()
    private lazy var viewModel: ProductViewModel = {
        ProductViewModel(categoryId: category?.category_id ?? "")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = shadowView.frame.size
        gradientLayer.colors = [UIColor.white.cgColor,UIColor.gray.withAlphaComponent(0.3).cgColor]
        gradientLayer.locations = [0.3, 1.0]
        shadowView.layer.addSublayer(gradientLayer)
        
        configNotification()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        contentTableView.separatorStyle = .none
        contentTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: contentTableView.frame.width, height: 50))
        headerView.backgroundColor = .clear
        headerLabel.localizationKey = "\("creative_sphere_t_shirts".localized) \(category?.name.localized ?? "")"
        headerLabel.font = UIFont(name: "Oswald-SemiBold", size: 20)!
        headerLabel.textAlignment = .center
        headerLabel.adjustsFontSizeToFitWidth = true
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.minimumScaleFactor = 0.5
        let horizontalConstr = headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        let leftConstr = headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 8)
        let rightConstr = headerLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -8)
        headerView.addConstraints([horizontalConstr, leftConstr, rightConstr])
        
        contentTableView.tableHeaderView = headerView
        
        viewModel.$nodes.sink(receiveValue: {[weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self?.contentTableView.reloadData()
            })
            
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
            guard inProgress else {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                    self?.view.removeBluerLoader()
                })
                return
            }
            self?.view.showBlurLoader()
        }).store(in: &cancellable)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
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
    
    func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizationChange(_:)), name: Notification.Name("LocalizationChanged"), object: nil)
    }
    
    @objc func localizationChange(_ notification: Notification) {
        viewModel.loadData()
        headerLabel.localizationKey = "\("creative_sphere_t_shirts".localized) \(category?.name.localized ?? "")"
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailViewController
        let model = viewModel.nodes[indexPath.section]
        vc.viewModel = ProductDetailViewModel(productId: model.id, branchName: categoryName)
        self.navigationController?.pushViewController(vc, animated: false)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.nodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let productItem = viewModel.nodes[indexPath.section]
        cell.configure(for: productItem)
        cell.delegate = self
        return cell
    }

}
// MARK: UIGestureRecognizerDelegate

extension ProductsViewController: UIGestureRecognizerDelegate {
    
}

extension ProductsViewController: ProductTableViewCellDelegate {
    func toCartButtonDidClick(model: ProductItemModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetail") as! ProductDetailViewController
        vc.viewModel = ProductDetailViewModel(productId: model.id, branchName: categoryName)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
