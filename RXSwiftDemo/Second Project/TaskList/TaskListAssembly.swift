//
//  TaskListAssembly.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit

final class TaskListAssembly {
    static func configure() -> UIViewController {
        let view = TaskListViewController()
        return UINavigationController(rootViewController: view)
    }
}
