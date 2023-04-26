//
//  WeatherResult.swift
//  appWeather
//
//  Created by Vadim Baburin on 31.03.2023.
//

import Foundation

struct WeatherResult: Codable {
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
