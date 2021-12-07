//
//  LocalStorageManager.swift
//  AmberShop
//
//  Created by Kirill on 30.11.2021.
//

import Foundation

enum LocalKey: String {
    case savedProducts
    case localization
}

class LocalStorageManager {
    
    static let shared = LocalStorageManager()
    
    typealias GenericRemove = (Codable & Equatable)
    
    private let storage = UserDefaults.standard
    
    private init() { }
    
    func set<T>(key: LocalKey, value: T) {
        storage.setValue(value, forKey: key.rawValue)
    }
    
    func add<T: Codable>(key: LocalKey, value: T) {
        guard var array: [T] = get(key: key) else {
            set(key: key, value: [value])
            return
        }
        array.append(value)
        set(key: key, value: array)
    }
    
    func remove<T: GenericRemove>(key: LocalKey, value: T) {
        guard var array: [T] = get(key: key) else {
            return
        }
        array.removeAll(where: {value == $0} )
        set(key: key, value: array)
    }
    
    func set<T: Codable>(key: LocalKey, value: T) {
        storage.setValue(try? JSONEncoder().encode(value) , forKey: key.rawValue)
    }

    func get<T: Decodable>(key: LocalKey) -> T? {
        guard let data = storage.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func clear(key: LocalKey) {
        storage.setValue(nil, forKey: key.rawValue)
    }
}
