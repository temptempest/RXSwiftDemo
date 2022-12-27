//
//  PhotosCell.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import SnapKit
final class PhotosCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView() 
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(self.snp.margins)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(image: UIImage?) {
        self.imageView.image = image
    }
    
}
