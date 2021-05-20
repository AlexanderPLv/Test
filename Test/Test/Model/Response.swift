//
//  Response.swift
//  Test
//
//  Created by Alexander Pelevinov on 19.05.2021.
//

import Foundation

struct Response: Codable {
    let code: Int
    let messageTitle: String
    let message: String
    let rid: String
    let downloadDate: String
    let rates: [JsonRate]
    let productState: Int
    let ratesDate: String
}
