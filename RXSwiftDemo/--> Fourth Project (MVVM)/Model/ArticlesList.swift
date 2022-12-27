//
//  Articles.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import Foundation

struct ArticlesList: Codable, Hashable {
    let status: String
    let articles: [Article]
}

extension ArticlesList {
    static var all: Resource<ArticlesList> = {
        let url = Constants.News.newsEndpoint.url
        return Resource(url: url)
    }()
}

extension ArticlesList {
    static var empty: ArticlesList {
        return ArticlesList(status: Constants.Strings.noData, articles: [])
    }
}

struct Article: Codable, Hashable {
    let title: String
    let articleDescription: String?
    enum CodingKeys: String, CodingKey {
        case title
        case articleDescription = "description"
    }
}
