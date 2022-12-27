//
//  TestViewController .swift
//  RXSwiftDemo
//
//  Created by temptempest on 25.12.2022.
//
// subject - is observable as well as the observer
import UIKit
import RxSwift
import RxCocoa
class TestFirstViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private func first() {
        let observable = Observable.of([1, 2, 3, 4])
        let observable2 = Observable.from([1, 2, 3, 4])
        _ = observable.subscribe { event in
            print(event)
        }
        let subscription2 = observable2.subscribe(onNext: { element in
            print(element)
        })
        subscription2.dispose()
    }
    private func second() {
        Observable<String>.create { observer in
            observer.onNext("A")
            observer.onCompleted()
            //            observer.onNext("?") // after of onCompleted never will be call
            return Disposables.create()
            // create func to create observer
        }.subscribe(onNext: { print($0) },
                    onError: { print($0) },
                    onCompleted: { print("Completed") },
                    onDisposed: { print("Disposed") })
        .disposed(by: disposeBag)
    }
    private func publishSubject() {
        let subject = PublishSubject<String>()
        subject.onNext("Issue 1")
        _ = subject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        subject.onNext("Issue 2")
        subject.onNext("Issue 3")
        // subject.dispose() //after dispose finish
    
        subject.onCompleted()
        subject.onNext("Issue 4")
    }
    private func behaviourSubject() {
        let subject = BehaviorSubject(value: "Initial value")
        subject.onNext("Last Issue")
        _ = subject.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        subject.onNext("Issue 1")
    }
    private func relaySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        subject.onNext("Issue 1")
        subject.onNext("Issue 2")
        subject.onNext("Issue 3")
        _ = subject.subscribe {
            print($0)
        }.disposed(by: disposeBag)
        subject.onNext("Issue 4")
        subject.onNext("Issue 5")
        subject.onNext("Issue 6")
        
        print("[Subscription 2]")
        _ = subject.subscribe {
            print($0)
        }
    } // the last count of bufferSize
    private func behavourRelay() {
        let relay = BehaviorRelay(value: ["Item 1"])
        // BehaviorRelay(value: [String]())
        var value = relay.value
        value.append("Item 2")
        value.append("Item 3")
        relay.accept(value)
        relay.asObservable()
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        behavourRelay()
    }
}
