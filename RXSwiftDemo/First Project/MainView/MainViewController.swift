//
//  MainViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import SnapKit
import RxSwift

final class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let filterService: FilterService = FilterServiceImpl()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var applyFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitle("Apply Filter", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(applyFilterButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupNavBar()
        view.addSubview(imageView)
        view.addSubview(applyFilterButton)
        setupConstraints()
        applyFilterButton.isHidden = true
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.snp.height).offset(-view.frame.size.height * 0.15)
        }
        applyFilterButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(60)
        }
    }
    
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "Camera Filter"
        let navRightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusTapped))
        navigationItem.rightBarButtonItem = navRightButtonItem
    }
}

extension MainViewController {
    @objc private func plusTapped() {
        if let viewController = PhotosCollectonAssembly.configure() as? PhotosCollectonViewController {
            viewController.selectedPhoto.subscribe(onNext: { [weak self] photo in
                OperationQueue.main.addOperation {
                    self?.updateUI(with: photo)
                }
            }).disposed(by: disposeBag)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func updateUI(with image: UIImage) {
        self.imageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @objc
    private func applyFilterButtonPressed() {
        guard let sourceImage = self.imageView.image else { return }
        filterService.applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                OperationQueue.main.addOperation {
                    self.imageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
}
