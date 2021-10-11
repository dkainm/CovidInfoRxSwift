//
//  NetworkManager.swift
//  covid info
//
//  Created by Alex Rudoi on 9/10/21.
//

import Foundation
import SVProgressHUD

final class NetworkManager {
    private init() {}
    
    static let shared = NetworkManager()
    
    let startUrl = "https://covid-19-data.p.rapidapi.com/"
    
    enum Endpoint: String {
        case countryData = "country/code"
        case listOfCountries = "help/countries"
    }
    
    let covidHeaders = [
        "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
        "x-rapidapi-key": "b289e75514msh07211691b90b471p19b6bcjsn798820341f6e"
    ]
    
    func getUrlString(with endpoint: Endpoint) -> URL? {
        guard let url = URL(string: startUrl + endpoint.rawValue) else {
            debugPrint("Not valid url")
            return nil
        }
        return url
    }
    
    func request<T: Decodable>(url: URL,
                               parameters: [String: Any]? = nil,
                               headers: [String: String]? = nil,
                               decodeFrom returnValue: T.Type,
                               responseHandler: @escaping (T?) -> Void) {
        
        SVProgressHUD.show()
        
        var components = URLComponents(string: url.absoluteString)!
        
        if let parameters = parameters {
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            SVProgressHUD.dismiss()
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode,
                  error == nil
            else {
                debugPrint("Error with getting data")
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(returnValue, from: data)
                
                responseHandler(responseObject)
                
            } catch let err {
                print(err)
            }
            
        }
        task.resume()
    }
}
