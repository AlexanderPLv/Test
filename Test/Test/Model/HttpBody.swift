//
//  HttpBody.swift
//  Test
//
//  Created by Alexander Pelevinov on 19.05.2021.
//

import Foundation

struct HttpBody {
    let uid: String
    let type: String
    let rid: String
    
    func toData() throws -> Data? {
            var json = [String: Any]()
            let mirror = Mirror(reflecting: self)
            for child in mirror.children {
                if let key = child.label?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    json[key] = child.value
                }
            }
            do {
                return try JSONSerialization.data(withJSONObject: json, options: [])
            } catch {
                throw error
            }
        }
    
}
