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
        configureLeftBar()
        configureRightBar()
        // Do any additional setup after loading the view.
    }
    
    func configureLeftBar() {
        let logoBtn: UIButton = UIButton()
        logoBtn.setImage(UIImage(named: "logo.icon"), for: .normal)
        logoBtn.setImage(UIImage(named: "logo.icon"), for: .highlighted)
        logoBtn.setImage(UIImage(named: "logo.icon"), for: .selected)
        logoBtn.isEnabled = false
        logoBtn.backgroundColor = .clear
        logoBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        logoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        let logoBarBtn = UIBarButtonItem(customView: logoBtn)

        self.navigationItem.setLeftBarButton(logoBarBtn, animated: false)
    }

    func configureRightBar() {
        let cartBtn: UIButton = UIButton()
        cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
        cartBtn.addTarget(self, action: #selector(cartButtonDidClick), for: .touchUpInside)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        cartBtn.tintColor = .white
        // 7D71B1
        cartBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        cartBtn.layer.cornerRadius = 15
        let cartBarBtn = UIBarButtonItem(customView: cartBtn)


        let menuBtn: UIButton = UIButton()
        menuBtn.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        menuBtn.addTarget(self, action: #selector(menuButtonDidClick), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuBtn.tintColor = .white
        menuBtn.backgroundColor = UIColor.hexColor(hex: "7D71B1")
        menuBtn.layer.cornerRadius = 15
        let menuBarBtn = UIBarButtonItem(customView: menuBtn)
        
        self.navigationItem.setRightBarButtonItems([menuBarBtn, cartBarBtn], animated: false)
    }
    
    @objc func cartButtonDidClick() {
        guard let basketData: [BasketWrapItem] = LocalStorageManager.shared.get(key: .savedProducts),
        !basketData.isEmpty else {
            showAlert(message: "basket_is_empty".localized, action: nil)
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
