//
//  CatalogViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 22.11.2021.
//

import UIKit

class CatalogViewController: BaseViewController {

    @IBOutlet weak var catalogTableView: UITableView!
    
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
            self?.catalogTableView.reloadData()
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
    }
    
    override func configureRightBar() {
        let cartBtn: UIButton = UIButton()
        cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
        cartBtn.addTarget(self, action: #selector(cartButtonDidClick), for: .touchUpInside)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        cartBtn.tintColor = .white
        cartBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        cartBtn.layer.cornerRadius = 15
        let cartBarBtn = UIBarButtonItem(customView: cartBtn)


        let closeBtn: UIButton = UIButton()
        closeBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeButtonDidClick), for: .touchUpInside)
        closeBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        closeBtn.tintColor = .white
        closeBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        closeBtn.layer.cornerRadius = 15
        let closeBarBtn = UIBarButtonItem(customView: closeBtn)
        
        self.navigationItem.setRightBarButtonItems([closeBarBtn, cartBarBtn], animated: false)
    }
    
    @objc private func contactsDidClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Contacts") as! ContactsViewController
        separateNaviationController?.popToRootViewController(animated: false)
        separateNaviationController?.pushViewController(vc, animated: false)
        self.dismiss(animated: true, completion: nil)
    }
}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(text: String) {
        titleLabel.text = text
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
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        sectionLabel.textAlignment = .left
        
        sectionView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstr = sectionLabel.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor)
        let leftConstr = sectionLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 20)
        sectionView.addConstraints([horizontalConstr, leftConstr])
        
        if section == 3 {
            let sectionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            let attributedString = NSAttributedString(string: viewModel.nodes[section].name, attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.black,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)
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