//
//  NetworkService.swift
//  APOD
//
//  Created by aksagarw on 14/05/22.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func getAstronomyData(completion: @escaping (Astronomy?, Error?) -> Void) {
        
        let url = URL(string: baseUrl + apiKey)
        guard let url = url else {
            print("Error: Invalid URL")
            completion(nil, NetworkError.invalidUrl)
            return
        }
        if Reachability.isConnectedToNetwork() {
            URLSession.shared.dataTask(with: url, completionHandler: { data, response, err in
                if err == nil {
                    guard let data = data else {
                        print("Error: No Data")
                        completion(nil, NetworkError.noData)
                        return
                    }
                    do {
                        let astronomyData = try JSONDecoder().decode(Astronomy.self, from: data)
                        print(astronomyData)
                        completion(astronomyData, nil)
                    } catch let err {
                        print("Error happened: \(err)")
                        completion(nil, err)
                    }
                }
            }).resume()
        } else {
            completion(nil, NetworkError.notConnected)
        }
    }
}

