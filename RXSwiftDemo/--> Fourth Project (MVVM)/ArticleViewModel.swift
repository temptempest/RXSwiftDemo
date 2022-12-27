//
//  ArticleViewModel.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import RxSwift

struct ArticleViewModel {
    let article: Article
    init(_ article: Article) {
        self.article = article
    }
}
extension ArticleViewModel {
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    var description: Observable<String> {
        return Observable<String>.just(article.articleDescription ?? "")
    }
}
