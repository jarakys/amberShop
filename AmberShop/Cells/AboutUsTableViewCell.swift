//
//  AboutUsTableViewCell.swift
//  AmberShop
//
//  Created by Kirill on 06.12.2021.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var descriptionLabel2: UILabel!
    @IBOutlet var actionDescriptionLabel: UILabel!
    
    @IBOutlet var img1: UIImageView!
    @IBOutlet var img2: UIImageView!
    @IBOutlet var img3: UIImageView!
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.localizationKey = "about_project"
        descriptionLabel.localizationKey = "about_us_description"
        
        label1.localizationKey = "promptly"
        label2.localizationKey = "individually"
        label3.localizationKey = "creatively"
        
        descriptionLabel2.localizationKey = "about_us_description1"
        
        actionDescriptionLabel.localizationKey = "subscribe_to_us"
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func facebookDidTap(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/AmberLawCompany/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func instagramDidTap(_ sender: Any) {
        if let url = URL(string: "https://www.instagram.com/amberlawcompany/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func youtubeDidTap(_ sender: Any) {
        if let url = URL(string: "https://www.youtube.com/channel/UCfRtugfqKg2tAk_cCtZ3rog") {
            UIApplication.shared.open(url)
        }
    }
}
