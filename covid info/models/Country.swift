//
//  Country.swift
//  covid info
//
//  Created by Alex Rudoi on 9/10/21.
//

import Foundation

struct Country: Decodable {
    let name: String
    let code: String?
    
    enum CodingKeys: String, CodingKey {
        case name, code = "alpha2code"
    }
}
