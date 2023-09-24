//
//  ExtensionUserDefaults.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 21.09.2023.
//

import Foundation

extension UserDefaults {
    func saveData<T: Encodable>(someData: T, key: String) {
        let data = try? JSONEncoder().encode(someData)
        set(data, forKey: key)
        
    }
    
    func readData<T: Decodable>(type: T.Type, key: String) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        let newData = try? JSONDecoder().decode(type, from: data)
        return newData
    }
    
    func readDataFromArray<T: Decodable>(type: T.Type, key: String) -> [T]? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        let array = try? JSONDecoder().decode([T].self, from: data)
        return array
    }
}
