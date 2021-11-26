//
//  NetwrokManager.swift
//  AmberShop
//
//  Created by Kirill on 26.11.2021.
//

import Foundation

import Foundation
enum APIError: Error {
    case noData
    case invalidURL
}


class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    private override init() { super.init() }
    
    private lazy var session: URLSession = {
        URLSession(configuration: .default)
    }()
    
    func sendRequest(route: APIRouter, completion: @escaping(Result<Data, Error>) -> Void) {
        do {
            let task = session.dataTask(with: try route.asURLRequest()) {(data, response, error) in
                var result: Result<Data, Error>
                if let error = error {
                    result = .failure(error)
                } else if let data = data {
                    result = .success(data)
                } else {
                    result = .failure(APIError.noData)
                }
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            task.resume()
        } catch {
            completion(.failure(APIError.invalidURL))
        }
    }
    
    func cancelWithUrlRequest(with route: APIRouter) {
        session.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest == (try? route.asURLRequest()) }.first?
                .cancel()
        }
    }
}
