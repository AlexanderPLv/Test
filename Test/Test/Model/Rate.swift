//
//  Rate.swift
//  Test
//
//  Created by Alexander Pelevinov on 19.05.2021.
//

import Foundation

struct JsonRate: Codable {
    let tp: Int
    let name: String
    let from: Int
    let currMnemFrom: CurrMnemFrom
    let to: Int
    let currMnemTo: String
    let basic: String
    let buy: String
    let sale: String
    let deltaBuy: String
    let deltaSale: String
}

enum CurrMnemFrom: String, Codable {
    case eur = "EUR"
    case gbp = "GBP"
    case rur = "RUR"
    case usd = "USD"
}
