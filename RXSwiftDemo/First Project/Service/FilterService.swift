//
//  FilterService.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import CoreImage
import RxSwift

protocol FilterService {
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage>
}

final class FilterServiceImpl: FilterService {
    private var context: CIContext
    private let ciFilterName = "CICMYKHalftone"
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping (UIImage) -> Void) {
        let filter = CIFilter(name: ciFilterName)
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        if let sourceImage = CIImage(image: inputImage) {
            filter?.setValue(sourceImage, forKey: kCIInputImageKey)
            if let filter = filter,
               let outputImage = filter.outputImage,
               let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
