//
//  CountryData.swift
//  covid info
//
//  Created by Alex Rudoi on 9/10/21.
//

import Foundation

struct CountryData: Decodable {
    let country: String
    let confirmed: Int
    let recovered: Int
    let deaths: Int
    let lastUpdate: String?
}
