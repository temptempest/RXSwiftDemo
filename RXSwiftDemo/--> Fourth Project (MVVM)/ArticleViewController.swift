//
//  ArticleVC.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import SnapKit
import RxSwift

final class ArticleViewController: UIViewController, UITableViewDelegate {
    private typealias Model = Article
    private typealias DataSource = UITableViewDiffableDataSource<Section, Model>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Model>
    
    private var disposeBag = DisposeBag()
    private var tableView: UITableView!
    private var dataSource: DataSource!
    
    var viewModel: IArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [.setupUI, .setupConstraints, .makeDataSouce, .getNews].forEach(perform)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [.setupNavBar, .setupTableView].forEach(perform)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        title = Constants.Strings.newsApp
        self.navigationController?.applyDarkNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - UITableViewDiffableDataSource
extension ArticleViewController {
    private enum Section {
        case main
    }
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.register([ArticleCell.self])
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    private func makeDataSouce() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, _, article in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier) as? ArticleCell else {
                return UITableViewCell()
            }
            cell.configure(article: article)
            return cell
        })
    }
    
    private func updateDataSource(_ data: [Model]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
        self.tableView.reloadData()
    }
}
// MARK: - UITableViewDelegate
extension ArticleViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articleVM = viewModel.articleAt(indexPath.row)
        print(articleVM)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ArticleViewController {
    private func getNews() {
        viewModel.getNews()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] articles in
                self?.viewModel = ArticleListViewModel(articles)
                self?.perform(.updateDataSource(articles))
            }).disposed(by: disposeBag)
    }
}

// MARK: - Actions
extension ArticleViewController {
    private enum ArticleVCActions {
        case setupUI
        case setupConstraints
        case setupNavBar
        case setupTableView
        case makeDataSouce
        case getNews
        case updateDataSource(_ data: [Article])
    }
    
    private func perform(_ action: ArticleVCActions) {
        switch action {
        case .setupUI: setupUI()
        case .setupConstraints: setupConstraints()
        case .setupNavBar: setupNavBar()
        case .setupTableView: setupTableView()
        case .makeDataSouce: makeDataSouce()
        case .getNews: getNews()
        case .updateDataSource(let data): updateDataSource(data)
        }
    }
}
