//
//  TestFourthViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import RxSwift

final class TestFourthViewController: UIViewController {
    let disposeBag = DisposeBag()
    private func startWith() {
        let numbers = Observable.of(2, 3, 4)
        let observable = numbers.startWith(1)
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    private func concat() {
        let first = Observable.of(1, 2, 3)
        let second = Observable.of(4, 5, 6)
        let observable = Observable.concat([first, second])
        
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    private func merge() {
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()
         
        let source = Observable.of(left.asObserver(), right.asObserver())
        let observable = source.merge()
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        left.onNext(5)
        left.onNext(3)
        
        right.onNext(2)
        right.onNext(1)
        right.onNext(99)
    }
    private func combineLatest() {
        let left = PublishSubject<Int>()
        let right = PublishSubject<Int>()
        
        let observable = Observable.combineLatest(left, right) { lastLeft, lastRight in
            "\(lastLeft) \(lastRight)"
        }
        
        observable.subscribe(onNext: { value in
            print(value)
        }).disposed(by: disposeBag)
        
        left.onNext(45)
        right.onNext(1)
        left.onNext(30)
        right.onNext(1)
        right.onNext(2)
    } // get the last value of the left and right sequence
    private func withLatestFrom() {
        let button = PublishSubject<String>()
        let textField = PublishSubject<String>()
        
        let observable = button.withLatestFrom(textField)
        observable.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        textField.onNext("Sw")
        textField.onNext("Swif")
        textField.onNext("Swift Rocks!")
        
        button.onNext("")
        button.onNext("")
    }
    private func reduce() {
        let source = Observable.of(1, 2, 3)
        source.reduce(0, accumulator: +)
            .subscribe(onNext: {
                 print($0)
            }).disposed(by: disposeBag)
        
        source.reduce(0) { summary, newValue in
            return summary + newValue
        }.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    } // same
    private func scan() {
        let source = Observable.of(1, 2, 3, 4, 5, 6)
        source.scan(0, accumulator: +)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        scan()
    }
}
