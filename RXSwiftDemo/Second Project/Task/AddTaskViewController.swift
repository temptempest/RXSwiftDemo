//
//  AddTaskViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import RxSwift
import SnapKit

final class AddTaskViewController: UIViewController {
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObserver()
    }
    
    private let options = ["High", "Medium", "Low"]
    
    private lazy var segmentController: UISegmentedControl = {
        let segmentedControll = UISegmentedControl(items: options)
        return segmentedControll
    }()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "Add task ..."
        textField.layer.cornerRadius = 8
        textField.layer.cornerCurve = .continuous
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Add Task"
        let navRightButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = navRightButtonItem
        segmentController.selectedSegmentIndex = 0
        view.addSubview(segmentController)
        view.addSubview(taskTextField)
    }
    
    private func setupConstraints() {
        segmentController.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
        taskTextField.snp.makeConstraints {
            $0.top.equalTo(segmentController.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
    }
    
    @objc
    private func saveTapped() {
        guard let priority = Priority(rawValue: self.segmentController.selectedSegmentIndex + 1),
        let title = self.taskTextField.text else { return }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.navigationController?.popViewController(animated: true)
    }
}
