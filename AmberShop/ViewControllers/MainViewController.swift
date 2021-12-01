//
//  ViewController.swift
//  AmberShop
//
//  Created by Kyrylo Chernov on 20.11.2021.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    private lazy var viewModel: MainViewModel = {
        MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNotification()
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(UINib(nibName: "LabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LabelCollectionViewCell")
        contentCollectionView.allowsSelection = true
        photoImageView.image = UIImage(named: "testImg2")
        titleLabel.localizationKey = "t_shirts_by_industry"
        titleLabel.font = .boldSystemFont(ofSize: 25)
        viewModel.$nodes.sink(receiveValue: {[weak self] _ in
            DispatchQueue.main.async {
                self?.contentCollectionView.reloadData()
            }
        }).store(in: &cancellable)
        
        viewModel.$error.sink(receiveValue: {[weak self] error in
            guard let error = error else { return }
            let alert = UIAlertController(title: "error".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(.init(title: "retry".localized, style: .default, handler: {_ in
                self?.viewModel.loadData()
            }))
            self?.present(alert, animated: true, completion: nil)
        }).store(in: &cancellable)
        
        viewModel.$inProgress.sink(receiveValue: {[weak self] inProgress in
            //TODOs Dimas
        }).store(in: &cancellable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel.loadData()
    }
    
    func configNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(localizationChange(_:)), name: Notification.Name("LocalizationChanged"), object: nil)
    }
    
    @objc func localizationChange(_ notification: Notification) {
        viewModel.loadData()
        
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCollectionViewCell", for: indexPath) as! LabelCollectionViewCell
        let category = viewModel.nodes[indexPath.row]
        cell.setTitle(text: category.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LabelCollectionViewCell else { return }
        
        cell.backgroundColor = UIColor.hexColor(hex: "223766")
        
        let category = viewModel.nodes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Products") as! ProductsViewController
        vc.category = category
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
//        self.present(navController, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? LabelCollectionViewCell {
            cell.backgroundColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.width / 3) - 20
            return CGSize(width: width, height: 60)
    }
}
