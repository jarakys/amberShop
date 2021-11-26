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

    let coordinate = CLLocationCoordinate2D(latitude: 50.42065, longitude: 30.54739)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoView.backgroundColor = UIColor.hexColor(hex: "6786CE")
        infoView.tintColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        bottomLabel.font = .boldSystemFont(ofSize: 18)
        positionMapView.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Юредичесская копания АМБЕР"
        
        positionMapView.addAnnotation(annotation)
        footerLabel.text = "Amder-futbolka.com 2021 \u{24D2} Все права защищены"
        
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
        self.navigationController?.popViewController(animated: true)
    }

}
