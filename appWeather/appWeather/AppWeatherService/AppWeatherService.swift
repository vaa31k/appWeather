//
//  AppWeatherService.swift
//  appWeather
//
//  Created by Vadim Baburin on 28.03.2023.
//

import Foundation

struct GetWeatherData: Codable {
    let location: Location?
    let current: Current?
    let error: Error?
}
struct Location: Codable {
    let name: String?
}
struct Current: Codable {
    let temperature: Double
}
struct Error: Codable {
    let info: String?
}

class AppWeatherService {
    func getSearchInformation(searchText: String, completion: @escaping (GetWeatherData) -> Void) {
        let urlString =  "http://api.weatherstack.com/current?access_key=2b5a6e49306834779ea76ba4c518ee14&query=\(searchText.replacingOccurrences(of: " ", with: "%20"))".encodeUrl
        
        let url = URL(string: urlString)
        
        guard let unwrappedUrl = url else {
            print("url = nil")
            return
        }
        
        let task = URLSession.shared.dataTask(with: unwrappedUrl) { (data, response, error) in
            do {
                
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let rawResponse = try? decoder.decode (GetWeatherData.self, from: data) {
                        completion(rawResponse)
                        return
                    }
                }
                
            }
        }
        task.resume()
    }
}
