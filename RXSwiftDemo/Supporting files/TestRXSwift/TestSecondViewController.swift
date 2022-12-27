//
//  SecondViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import RxSwift

final class TestSecondViewController: UIViewController {
    let subject = PublishSubject<String>()
    let disposeBag = DisposeBag()
    private func ignore() {
        subject
            .ignoreElements()
            .subscribe { _ in
                print("[Subscription is called]")
            }.disposed(by: disposeBag)
        
        subject.onNext("A")
        subject.onNext("B")
        subject.onNext("C")
        
        subject.onCompleted()
    }
    private func elementAt() {
        _ = subject.element(at: 2)
        subject.subscribe(onNext: { _ in
            print("You are out!")
        }).disposed(by: disposeBag)
        
        subject.onNext("X")
        subject.onNext("X")
        subject.onNext("X")
    } // always out
    private func filter() {
        Observable.of(1, 2, 3, 4, 5, 6, 7)
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    } // analog filter
    private func skip() {
        Observable.of("A", "B", "C", "D", "F")
            .skip(3)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    private func skipWhile() {
        Observable.of(2, 2, 3, 4, 4)
            .skip { $0 % 2 == 0 } // skipWhile
            .subscribe(onNext: {
                 print($0)
            }).disposed(by: disposeBag)
    } // while first == true -> continue with all
    private func skipUntil() {
        let trigger = PublishSubject<String>()
        subject.skip(until: trigger)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        subject.onNext("A")
        subject.onNext("B")
       
        trigger.onNext("X") // trigger called
        subject.onNext("C")
        
    } // wait for a trigger
    private func take() {
        Observable.of(1, 2, 3, 4, 5)
            .take(3)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    } // take first count of elements
    private func takeWhile() {
        Observable.of(2, 4, 6, 7, 8, 10)
            .take(while: {$0 % 2 == 0})
//            .takeWhile{ return $0 % 2 == 0 } //takeWhile
            .subscribe(onNext: {
                print($0 )
            }).disposed(by: disposeBag )
    } // take first before apply condition
    private func takeUntil() {
        let trigger = PublishSubject<String>()
        subject.take(until: trigger) // takeUntil
            .subscribe(onNext: {
                 print($0)
            }).disposed(by: disposeBag)
        subject.onNext("1")
        subject.onNext("2")
        
        trigger.onNext("X")
        subject.onNext("3")
    } // ignore after add in trigger
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        takeUntil()
    }
}
