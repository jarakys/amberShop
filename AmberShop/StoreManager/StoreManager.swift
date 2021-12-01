//
//  StoreManager.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation

class StoreManager {
    
    static let shared = StoreManager()
    
    private init() { }
    
    private(set) var categories = [CategoryModel]()
    private(set) var menu = [MenuItemModel]()
    private(set) var deliveryInfoModel: DeliveryInfoModel?
    
    func initStore() {
        categories = []
        menu = []
        deliveryInfoModel = nil
        getCategories(completion: nil)
        getMenu(completion: nil)
        getDeliveryInfo(completion: nil)
    }
    
    func getCategories(completion: (([CategoryModel]?, Error?) -> Void)?) {
        guard categories.isEmpty else {
            completion?(categories, nil)
            return
        }
        
        NetworkManager.shared.sendRequest(route: .categories, completion: {result in
            switch result {
            case .success(let data):
                guard let categoriesObject = try? JSONDecoder().decode([CategoryModel].self, from: data) else {
                    completion?(nil, nil)
                    return
                }
                self.categories = categoriesObject
                completion?(self.categories, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    
    func getMenu(completion: (([MenuItemModel]?, Error?) -> Void)?) {
        guard menu.isEmpty else {
            completion?(menu, nil)
            return
        }

        NetworkManager.shared.sendRequest(route: .menu, completion: {result in
            switch result {
            case .success(let data):
                guard let menuObject = try? JSONDecoder().decode([MenuItemModel].self, from: data) else {
                    completion?(nil, nil)
                    return
                }
                self.menu = menuObject
                completion?(self.menu, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    func getDeliveryInfo(completion: ((DeliveryInfoModel?, Error?) -> Void)?) {
        guard deliveryInfoModel == nil else {
            completion?(deliveryInfoModel, nil)
            return
        }

        NetworkManager.shared.sendRequest(route: .delivery, completion: {result in
            switch result {
            case .success(let data):
                guard let deliveryObject = try? JSONDecoder().decode(DeliveryInfoModel.self, from: data) else {
                    completion?(nil, nil)
                    return
                }
                self.deliveryInfoModel = deliveryObject
                completion?(self.deliveryInfoModel, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
//
//    func getAllRadioStation(completion: @escaping([RadioStationModel]?, Error?) -> Void) {
//        guard radioStations.isEmpty else {
//            completion(radioStations, nil)
//            return
//        }
//
//        NetworkManager.shared.sendRequest(route: .radios, completion: {result in
//            switch result {
//            case .success(let data):
//                guard let radioStationsObject = try? JSONDecoder().decode([RadioStationModel].self, from: data) else {
//                    completion(nil, nil)
//                    return
//                }
//                self.radioStations = radioStationsObject
//                completion(radioStationsObject, nil)
//            case .failure(let error):
//                completion(nil, error)
//            }
//        })
//    }
//
//    func getRadioStationBy(genreId: Int, completion: @escaping([RadioStationModel]?, Error?) -> Void) {
//        func filterFunction(radioStations: [RadioStationModel]) -> [RadioStationModel] {
//            radioStations.filter({ $0.ge.contains(genreId) })
//        }
//
//        guard radioStations.isEmpty else {
//            completion(filterFunction(radioStations: radioStations), nil)
//            return
//        }
//
//        getAllRadioStation(completion: {radioStations, error in
//            guard let radioStations = radioStations else {
//                completion(nil, nil)
//                return
//            }
//            completion(filterFunction(radioStations: radioStations), nil)
//        })
//    }
//
//    func getRadioStationBy(cityId: Int, completion: @escaping([RadioStationModel]?, Error?) -> Void) {
//        func filterFunction(radioStations: [RadioStationModel]) -> [RadioStationModel] {
//            radioStations.filter({ $0.ci.contains(cityId) })
//        }
//
//        guard radioStations.isEmpty else {
//            completion(filterFunction(radioStations: radioStations), nil)
//            return
//        }
//
//        getAllRadioStation(completion: {radioStations, error in
//            guard let radioStations = radioStations else {
//                completion(nil, nil)
//                return
//            }
//            completion(filterFunction(radioStations: radioStations), nil)
//        })
//    }
}
