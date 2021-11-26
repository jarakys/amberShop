//
//  ProductsViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 23.11.2021.
//

import UIKit
import Presentr

class ProductsViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    
    public var category: CategoryModel?
    
    private lazy var viewModel: ProductViewModel = {
        ProductViewModel(categoryId: category?.category_id ?? "")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        contentTableView.separatorStyle = .none
        contentTableView.allowsSelection = false
        
//        contentTableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
//        contentTableView.backgroundColor = .white
//        contentTableView.layer.masksToBounds = false
//        contentTableView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
//        contentTableView.layer.shadowOpacity = 1
//        contentTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        contentTableView.layer.shadowRadius = 16
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: contentTableView.frame.width, height: 50))
        headerView.backgroundColor = .clear
        let headerLabel = UILabel()
        headerLabel.text = "Креативные футболки сферы \(category?.name ?? "")"
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.textAlignment = .center
        headerLabel.adjustsFontSizeToFitWidth = true
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.minimumScaleFactor = 0.5
        let horizontalConstr = headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        let leftConstr = headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor)
        let rightConstr = headerLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor)
        headerView.addConstraints([horizontalConstr, leftConstr, rightConstr])
        
        contentTableView.tableHeaderView = headerView
        
        viewModel.$nodes.sink(receiveValue: {[weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self?.contentTableView.reloadData()
            })
            
        }).store(in: &cancellable)
        
        viewModel.$error.sink(receiveValue: {[weak self] error in
            guard let error = error else { return }
            let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(.init(title: "Retry", style: .default, handler: {_ in
                self?.viewModel.loadData()
            }))
            self?.present(alert, animated: true, completion: nil)
        }).store(in: &cancellable)
        
        viewModel.$inProgress.sink(receiveValue: {[weak self] inProgress in
            //TODOs Dimas
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
        logoBtn.setImage(UIImage(named: "logo.icon"), for: .normal)
        logoBtn.setImage(UIImage(named: "logo.icon"), for: .highlighted)
        logoBtn.setImage(UIImage(named: "logo.icon"), for: .selected)
        logoBtn.isEnabled = false
        logoBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        logoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        let logoBarBtn = UIBarButtonItem(customView: logoBtn)

        self.navigationItem.setLeftBarButtonItems([backBarBtn, logoBarBtn], animated: false)
    }
    
    override func closeButtonDidClick() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
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
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let heaserView = UIView()
//        heaserView.backgroundColor = .clear
//        
//        return heaserView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        20
//    }

}
// MARK: UIGestureRecognizerDelegate

extension ProductsViewController: UIGestureRecognizerDelegate {
    
}

extension ProductsViewController: ProductTableViewCellDelegate {
    func toCartButtonDidClick(model: ProductItemModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Modal") as! ModalViewController
        vc.productItem = model
        presenter.presentationType = .popup
        let modifiedAnimation = CrossDissolveAnimation(options: .normal(duration: 0.2))
        presenter.transitionType = TransitionType.custom(modifiedAnimation)
        presenter.dismissTransitionType = TransitionType.custom(modifiedAnimation)
        customPresentViewController(presenter, viewController: vc, animated: true)
    }
}
