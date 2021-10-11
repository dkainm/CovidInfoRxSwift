//
//  ApiManager.swift
//  covid info
//
//  Created by Alex Rudoi on 9/10/21.
//

import Foundation
import UIKit

final class ApiManager {
    private init() {}
    
    static let shared = ApiManager()
    
    private let networkManager = NetworkManager.shared
    
    func getCountryData(country: Country, completion: @escaping (CountryData?) -> Void) {
        guard let url = networkManager.getUrlString(with: .countryData) else { return }
        
        let params: [String : Any] = [
            "code": country.code!,
            "format": "json"
        ]
        
        networkManager.request(url: url,
                               parameters: params,
                               headers: networkManager.covidHeaders,
                               decodeFrom: [CountryData].self) { countries in
            completion(countries?.first)
        }
    }
    
    func getListOfCountries(completion: @escaping ([Country]?) -> Void) {
        guard let url = networkManager.getUrlString(with: .listOfCountries) else { return }
        
        networkManager.request(url: url,
                               headers: networkManager.covidHeaders,
                               decodeFrom: [Country].self) { countries in
            completion(countries)
        }
    }
    
}
