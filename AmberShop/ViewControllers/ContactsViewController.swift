//
//  ContactsViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 23.11.2021.
//

import UIKit
import MapKit

class ContactsViewController: BaseViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var positionMapView: MKMapView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var scheduleTextView: UITextView!
    @IBOutlet weak var adressTextView: UITextView!
    
    let coordinate = CLLocationCoordinate2D(latitude: 50.42065, longitude: 30.54739)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoView.backgroundColor = UIColor.hexColor(hex: "6786CE")
        infoView.tintColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.localizationKey = "contacts_lower"
        
        bottomLabel.font = .boldSystemFont(ofSize: 18)
        bottomLabel.localizationKey = "we_in_social_networks"
        positionMapView.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.localizationKey = "legal_company_amber"
        
        positionMapView.addAnnotation(annotation)
        footerLabel.localizationKey = "all_rights_reserved"
        adressTextView.localizationKey = "shop_adress"
        scheduleTextView.localizationKey = "schedule"
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func youtubeDidClick(_ sender: Any) {
        if let url = URL(string: "https://www.youtube.com/channel/UCfRtugfqKg2tAk_cCtZ3rog") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func twitterDidClick(_ sender: Any) {
        if let url = URL(string: "https://www.instagram.com/amberlawcompany/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func facebookDidClick(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/AmberLawCompany/") {
            UIApplication.shared.open(url)
        }
    }
}
