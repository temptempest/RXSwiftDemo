//
//  PhotosCollectonViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import RxSwift
import Photos

final class PhotosCollectonViewController: UIViewController, UICollectionViewDelegate {
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObserver()
    }
    
    private typealias Model = PHAsset
    private typealias UserDataSource = UICollectionViewDiffableDataSource<Section, Model>
    private typealias PhotoSnapshot = NSDiffableDataSourceSnapshot<Section, Model>
    private var collectionView: UICollectionView!
    private var dataSource: UserDataSource!
    private var images = [PHAsset]()
    private let imageManager = PHImageManager.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populatePhotos()
        makeDataSouce()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                // access the photos from photo library
                let asserts = PHAsset.fetchAssets(with: .image, options: nil)
                asserts.enumerateObjects { object, _, _ in
                    self?.images.append(object)
                }
               
                OperationQueue.main.addOperation {
                    self?.updateDataSource()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectonViewController {
    private enum Section {
        case main
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 120, height: 120)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.self.description())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func makeDataSouce() {
        dataSource = UserDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, _ in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotosCell.self.description(),
                for: indexPath) as? PhotosCell
            else { return UICollectionViewCell() }
            let assert = self.images[indexPath.item]
            
            self.imageManager.requestImage(for: assert,
                                           targetSize: .init(width: 100, height: 100),
                                           contentMode: .aspectFit, options: nil) { image, _ in
                DispatchQueue.main.async {
                    cell.configure(image: image)
                }
            }
            return cell
        })
    }
    
    private func updateDataSource() {
        images.reverse()
        let data: [Model] = self.images
        var snapshot = PhotoSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }    
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectonViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAssert = self.images[indexPath.item]
        imageManager.requestImage(for: selectedAssert,
                                  targetSize: .init(width: 100, height: 100 ),
                                  contentMode: .aspectFit,
                                  options: nil) { [weak self] image, info in
            guard let info = info else { return }
            if let isDegradedImage = info["PHImageResultIsDegradedKey"] as? Bool {
                if !isDegradedImage {
                    if let image = image {
                        self?.selectedPhotoSubject.onNext(image)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
