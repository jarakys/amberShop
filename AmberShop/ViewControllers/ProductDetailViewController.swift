//
//  ProductDetailViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 01.12.2021.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
    }

}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
