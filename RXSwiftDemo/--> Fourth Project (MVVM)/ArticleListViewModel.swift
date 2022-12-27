//
//  ArticleListViewModel.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import RxSwift

protocol IArticleListViewModel {
    init(_ articles: [Article])
    func articleAt(_ index: Int) -> ArticleViewModel
    func getNews() -> Observable<[Article]>
}

struct ArticleListViewModel: IArticleListViewModel {
    private let articlesVM: [ArticleViewModel]
    private let disposeBag = DisposeBag()
}
extension ArticleListViewModel {
    
    init(_ articles: [Article]) {
        self.articlesVM = articles.compactMap(ArticleViewModel.init)
    }
    
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesVM[index]
    }
    
    func getNews() -> Observable<[Article]> {
        return Observable<[Article]>.create { observer in
            self.downloadNews { articles in
                observer.onNext(articles)
            }
            return Disposables.create()
        }
    }
}

extension ArticleListViewModel {
    private func downloadNews(completion: @escaping ([Article]) -> Void) {
        Observers.articlesListObserver
            .retry(3)
            .catch { error in
                print(error.localizedDescription)
                return Observable.just(ArticlesList.empty)
            }.subscribe(onNext: { result in
                let articles = result.articles
                completion(articles)
            }).disposed(by: disposeBag)
    }
}

// MARK: - MockVM
struct ArticleListViewModelMock: IArticleListViewModel {
    private let articlesVM: [ArticleViewModel]
    init(_ articles: [Article]) {
        self.articlesVM = articles.compactMap(ArticleViewModel.init)
    }
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesVM[index]
    }
    func getNews() -> Observable<[Article]> {
        return Observable<[Article]>.create { observer in
            let result = loadJson(bundle: .main, fileName: "articles", type: ArticlesList.self)
            observer.onNext(result.articles)
            return Disposables.create()
        }
    }
}
