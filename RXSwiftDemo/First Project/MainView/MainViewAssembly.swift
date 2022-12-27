//
//  MainViewAssembly.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit

final class MainViewAssembly {
    static func configure() -> UIViewController {
        let view = MainViewController()
        return UINavigationController(rootViewController: view)
    }
}
