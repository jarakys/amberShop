//
//  APIRouter.swift
//  AmberShop
//
//  Created by Kirill on 20.11.2021.
//

import Foundation

enum APIRouter {
    
    case categories
    case menu
    case product(categoryId: String)
    case sendOrder(orderRequestModel: OrderRequestModel)
    case delivery

    private static let apiKey = "api_key=123456789"
    static let host = "https://amber-futbolka.com/index.php?route=common/api"
    
    var localization: String {
        var localization: String = LocalStorageManager.shared.get(key: .localization) ?? ""
        if localization == "ru" {
            localization = ""
        }
        return localization
    }
    
    private var method: String {
        switch self {
        case .categories, .menu, .product, .delivery:
            return "GET"
        default: return "POST"
        }
    }
    
    private var path: String {
        switch self {
        case .categories:
            return "/categories\(localization)&\(Self.apiKey)"
        case .menu:
            return "/menu\(localization)&\(Self.apiKey)&menu_id=1"
        case .product(let categoryId):
            return "/products\(localization)&\(Self.apiKey)&category_id=\(categoryId)"
        case .delivery:
            return "/delivery\(localization)"
        case .sendOrder:
            return "/add_order"
        }
    }
    
    private var headers: [String: String]? {
        return ["Content-Type":"application/json", "Accept":"application/json"]
    }
    
    // MARK: - Parameters
    private var parameters: OrderRequestModel? {
        switch self {
        case .sendOrder(let orderRequestModel):
            return orderRequestModel
        default : return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: Self.host + path) else {
            throw URLError(URLError.Code.unsupportedURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = headers
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(parameters)
            } catch  {
                
            }
        }
        return urlRequest
    }
}
