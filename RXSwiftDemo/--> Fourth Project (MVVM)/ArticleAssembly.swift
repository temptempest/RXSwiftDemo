//
//  ArticleAssembly.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit

final class ArticleAssembly {
    public enum ArticleAssemblyType {
        case mock
        case real
    }
    
    static func configure(_ type: ArticleAssemblyType = .mock) -> UIViewController {
        let view = ArticleViewController()
        let viewModel: IArticleListViewModel
        switch type {
        case .mock:
            viewModel = ArticleListViewModelMock([])
        case .real:
            viewModel = ArticleListViewModel([])
        }
        view.viewModel = viewModel
        return UINavigationController(rootViewController: view)
    }
}
