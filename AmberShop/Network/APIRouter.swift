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

    private static let apiKey = "api_key=123456789"
    static let host = "https://amber-futbolka.com/index.php?route=common/api"

    
    private var method: String {
        switch self {
        case .categories, .menu, .product:
            return "GET"
        default: return "POST"
        }
    }
    
    private var path: String {
        switch self {
        case .categories:
            return "/categories&\(Self.apiKey)"
        case .menu:
            return "/menu&\(Self.apiKey)&menu_id=1"
        case .product(let categoryId):
            return "/products&\(Self.apiKey)&category_id=\(categoryId)"
        }
    }
    
    private var headers: [String: String]? {
        return ["Content-Type":"application/json", "Accept":"application/json"]
    }
    
    // MARK: - Parameters
    private var parameters: [String:Any]? {
        return nil
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
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch  {
                
            }
        }
        return urlRequest
    }
}
