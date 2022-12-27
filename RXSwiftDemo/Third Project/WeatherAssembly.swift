//
//  WeatherAssembly.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit

final class WeatherAssembly {
    static func configure() -> UIViewController {
        let view = WeatherViewController()
        return UINavigationController(rootViewController: view)
    }
}
