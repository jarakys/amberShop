//
//  BaseViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 22.11.2021.
//

import UIKit
import Presentr
import Combine

class BaseViewController: UIViewController {

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .popup)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    public var cancellable = [AnyCancellable]()
    
    deinit {
        cancellable.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 10
        
        configureLeftBar()
        configureRightBar()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LocalizationChanged"), object: nil, queue: .main, using: {[weak self] _ in
            self?.configureLeftBar()
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("AddedToBasket"), object: nil, queue: .main, using: {[weak self] _ in
            self?.configureRightBar()
        })
    }
    
    func configureLeftBar() {
        let logoBtn: UIButton = UIButton()
        logoBtn.setImage(UIImage(named: "logo".localized), for: .normal)
        logoBtn.setImage(UIImage(named: "logo".localized), for: .highlighted)
        logoBtn.setImage(UIImage(named: "logo".localized), for: .selected)
        logoBtn.isEnabled = false
        logoBtn.backgroundColor = .clear
        logoBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        logoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 100)
        let logoBarBtn = UIBarButtonItem(customView: logoBtn)

        self.navigationItem.setLeftBarButton(logoBarBtn, animated: false)
    }

    func configureRightBar() {
        let cartBtn: UIButton = UIButton()
        cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
        cartBtn.addTarget(self, action: #selector(cartButtonDidClick), for: .touchUpInside)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        cartBtn.tintColor = .white
        // 7D71B1
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


        let menuBtn: UIButton = UIButton()
        menuBtn.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuBtn.addTarget(self, action: #selector(menuButtonDidClick), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        menuBtn.tintColor = .white
        menuBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        menuBtn.layer.cornerRadius = 13
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.setRightBarButtonItems([menuBarBtn, cartBarBtn], animated: false)
    }
    
    @objc func cartButtonDidClick() {
        guard let basketData: [BasketWrapItem] = LocalStorageManager.shared.get(key: .savedProducts),
        !basketData.isEmpty else {
            showAlert(message: "basket_is_empty".localized, title: "", action: nil)
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Cart") as! CartViewController
        navigationController?.pushViewController(vc, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    public func showAlert(message: String, title: String = "error", action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title.localized, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "ok".localized, style: .default, handler: {_ in
            action?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func menuButtonDidClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Catalog") as! CatalogViewController
        let navController = UINavigationController(rootViewController: vc)
        vc.separateNaviationController = self.navigationController!
        presenter.presentationType = .fullScreen
        presenter.transitionType = TransitionType.custom(CustomAnimation())
        presenter.dismissTransitionType = TransitionType.custom(CustomAnimation())
        customPresentViewController(presenter, viewController: navController, animated: true)
    }
    
    @objc func closeButtonDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}

class CustomAnimation: PresentrAnimation {

    override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        return CGRect(x: UIScreen.main.bounds.maxX, y: 0, width: 10, height: 10)
    }

}
