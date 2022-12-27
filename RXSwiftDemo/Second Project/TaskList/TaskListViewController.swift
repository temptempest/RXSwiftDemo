//
//  TaskViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TaskListViewController: UIViewController, UITableViewDelegate {
    private let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    private let options = ["All", "High", "Medium", "Low"]
    private lazy var segmentController: UISegmentedControl = {
        let segmentedControll = UISegmentedControl(items: options)
        segmentedControll.addTarget(self, action: #selector(priorityValueChanged(segmentedControl:)), for: .valueChanged)
        return segmentedControll
    }()
    
    private var tableView: UITableView!
    private typealias Model = Task
    private typealias DataSource = UITableViewDiffableDataSource<Section, Model>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Model>
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        makeDataSouce()
    }
    
    private func setupUI() {
        title = "Good List"
        view.backgroundColor = .white
        setupNavBar()
        segmentController.selectedSegmentIndex = 0
        view.addSubview(segmentController)
        setupTableView()
    }
    
    private func setupConstraints() {
        segmentController.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentController.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "Task List"
        let navRightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusTapped))
        navigationItem.rightBarButtonItem = navRightButtonItem
    }
    
    @objc func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: self.segmentController.selectedSegmentIndex)
        filterTask(by: priority)
    }
    
    @objc
    private func plusTapped() {
        if let viewController = AddTaskAssembly.configure() as? AddTaskViewController {
            viewController.taskSubjectObservable
                .subscribe(onNext: { [weak self] task in
                    guard let self else { return }
                    let priority = Priority(rawValue: self.segmentController.selectedSegmentIndex)
                     
                    var existingTasks: [Task] = self.tasks.value
                    existingTasks.append(task)
                    self.tasks.accept(existingTasks)
                    self.filterTask(by: priority)
                }).disposed(by: disposeBag)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func filterTask(by priority: Priority?) {
        if priority == .all {
            self.filteredTasks = self.tasks.value
            self.updateDataSource(filteredTasks)
        } else {
             self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority  }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                guard let self else {return}
                self.updateDataSource(self.filteredTasks)
            }).disposed(by: disposeBag)
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    private enum Section {
        case main
    }
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    private func makeDataSouce() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, _ in
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
            cell?.textLabel?.text = self.filteredTasks[indexPath.row].title
            //            else { return UITableViewCell() }
            //            cell.configure(country: country)
            return cell
        })
    }
    
    private func updateDataSource(_ data: [Model]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
// MARK: - UITableViewDelegate
extension TaskListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tap")
    }
}
