//
//  TestThirdViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class TestThirdViewController: UIViewController {
    let disposeBag = DisposeBag()
    private func toArray() {
        Observable.of(1, 2, 3, 4, 5)
            .toArray()
            .subscribe({
                print($0)
            }).disposed(by: disposeBag)
    } // just map with join
    private func map() {
        Observable.of(1, 2, 3, 4, 5)
            .map {
                return $0 * 2
            } .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    private func flatMap() {
        struct Student {
            var score: BehaviorRelay<Int>
        }
        
        let john = Student(score: BehaviorRelay(value: 75))
        let mary = Student(score: BehaviorRelay(value: 95))
        
        let student = PublishSubject<Student>()
        student.asObserver()
            .flatMap { $0.score.asObservable() }
            .subscribe(onNext: {
                 print($0)
            }).disposed(by: disposeBag)
        
        student.onNext(john)
        john.score.accept(100)
        student.onNext(mary)
        mary.score.accept(80)
    }
    private func flatMapLatest() {
        struct Student {
            var score: BehaviorRelay<Int>
        }
        
        let john = Student(score: BehaviorRelay(value: 75))
        let mary = Student(score: BehaviorRelay(value: 95))
        
        let student = PublishSubject<Student>()
        student.asObserver()
            .flatMapLatest { $0.score.asObservable() }
            .subscribe(onNext: {
                 print($0)
            }).disposed(by: disposeBag)
        
        student.onNext(john)
        john.score.accept(100)
        
        student.onNext(mary)

        john.score.accept(45)
        
    } // only observe the latest value
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        flatMapLatest()
    }
}
