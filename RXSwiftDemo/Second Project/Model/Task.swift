//
//  Task.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import Foundation

struct Task: Hashable {
    let title: String
    let priority: Priority
}

enum Priority: Int {
    case all
    case high
    case medium
    case low
}
