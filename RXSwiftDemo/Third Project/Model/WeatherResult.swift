//
//  Weather.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import Foundation

struct WeatherResult: Codable, Hashable {
    let main: Weather
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}

struct Weather: Codable, Hashable {
    let temp: Double
    let humidity: Double
}
