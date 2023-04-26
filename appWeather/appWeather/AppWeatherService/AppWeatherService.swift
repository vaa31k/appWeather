//
//  AppWeatherService.swift
//  appWeather
//
//  Created by Vadim Baburin on 28.03.2023.
//

import Foundation

class AppWeatherService {
    func getSearchInformation(searchText: String, completion: @escaping (WeatherResult) -> Void) {
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
                    if let rawResponse = try? decoder.decode (WeatherResult.self, from: data) {
                        completion(rawResponse)
                        return
                    }
                }
                
            }
        }
        task.resume()
    }
}
