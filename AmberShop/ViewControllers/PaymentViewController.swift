//
//  PaymentViewController.swift
//  AmberShop
//
//  Created by Kirill on 07.12.2021.
//

import UIKit
import Cloudipsp

class PaymentViewController: BaseViewController {
    
    @IBOutlet var cardInputView: PSCardInputView!

    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var applePayButton: UIButton!
    @IBOutlet var payButton: UIButton!
    
    private var webView: PSCloudipspView!
    
    public var completion: ((Bool)-> Void)?
    
    private lazy var psCloudipspApi: PSCloudipspApi = {
        PSCloudipspApi(merchant: 1492633, andCloudipspView: webView)
    }()
    
    public var viewModel: PaymentViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = viewModel.customerEmail
        payButton.setTitle("\("pay".localized) \(viewModel.sum) ГРН", for: .normal)
        configNotification()
        setupWebView()
        cardInputView.inputDelegate = self
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
    
    override func viewDidDisappear(_ animated: Bool) {
        completion?(false)
    }
    
    func setupWebView() {
        webView = PSCloudipspWKWebView(frame: CGRect(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height - 66))
        guard let view = webView as? UIView else { return }
        self.view.addSubview(view)
    }
    
    func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizationChange(_:)), name: Notification.Name("LocalizationChanged"), object: nil)
    }
    
    @objc func localizationChange(_ notification: Notification) {
        payButton.setTitle("\("pay".localized) \(viewModel.sum) ГРН", for: .normal)
    }

    @IBAction func applePayDidTap(_ sender: Any) {
        if PSCloudipspApi.supportsApplePay() {
            showAlert(message: "apple_pay_not_supported".localized)
        }
        let order = PSOrder(order: Int(viewModel.sum), aCurrency: PSCurrency.init(rawValue: 1), aIdentifier: Date().timeIntervalSince1970.description, aAbout: "AmberShop")
        psCloudipspApi.applePay(order, andDelegate: self)
    }
    
    @IBAction func payDidTap(_ sender: Any) {
        guard let card = cardInputView.confirm(self) else {
            return
        }
        
        let order = PSOrder(order: Int(viewModel.sum), aCurrency: PSCurrency.init(rawValue: 1), aIdentifier: Date().timeIntervalSince1970.description, aAbout: "AmberShop")
        
        psCloudipspApi.pay(card, with: order, andDelegate: self)
    }
}

extension PaymentViewController: PSApplePayCallbackDelegate {
    func onApplePayNavigate(_ viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: PSCardInputViewDelegate
extension PaymentViewController: PSCardInputViewDelegate, PSPayCallbackDelegate, PSConfirmationErrorHandler {
    
    func onPaidProcess(_ receipt: PSReceipt!) {
        showAlert(message: "ok".localized, title: "success".localized, action: {[weak self] in
            self?.completion?(true)
            self?.completion = nil
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    func onPaidFailure(_ error: Error!) {
        showAlert(message: error.localizedDescription)
    }
    
    func onWaitConfirm() {
        showAlert(message: "confirm_payment".localized, title: "attention".localized)
    }
    
    func onCardInputErrorClear(_ cardInputView: UIView!, aTextField textField: UITextField!) {
        
    }
    
    func onCardInputErrorCatched(_ cardInputView: UIView!, aTextField textField: UITextField!, aError error: PSConfirmationError) {
        switch error.rawValue {
        case 0:
            showAlert(message: "INVALID_CARD_NUMBER_KEY".localized)
        case 1:
            showAlert(message: "INVALID_EXPIRY_MONTH_KEY".localized)
        case 2:
            showAlert(message: "INVALID_EXPIRY_YEAR_KEY".localized)
        case 3:
            showAlert(message: "INVALID_EXPIRY_DATE_KEY".localized)
        case 4:
            showAlert(message: "INVALID_CVV_KEY".localized)
            
        default: showAlert(message: "error".localized)
        }
    }
    
    func didEndEditing(_ cardInputView: PSCardInputView!) {
        
    }
}
