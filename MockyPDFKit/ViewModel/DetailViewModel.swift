//
//  DetailViewModel.swift
//  MockyPDFKit
//
//  Created by Yefga on 01/08/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit
import PDFKit

final class DetailViewModel {
    
    let item: Item
    var storedPDFPage: PDFPage!
    var storedAnnotations: [PDFAnnotation] = []
    
    init(item: Item) {
        self.item = item
    }
    
    func setupPDF(onComplete: @escaping (PDFDocument) -> ()) {
        
        if let url = URL(string: item.file), let pdfDocument = PDFDocument(url: url) {
            onComplete(pdfDocument)
        }
    }
    
    func updateAnnotation(from view: PDFView, with image: UIImageView?) {
        
        if let currentPage = view.currentPage, let imageView = image {
            let currentPageHeight = currentPage.bounds(for: .mediaBox).height

            let yPosition = currentPageHeight - imageView.frame.origin.y
            let yPositionCondition = yPosition > 0 ? yPosition : 0
            storedPDFPage = view.currentPage

            let stampBound = CGRect(
                x: imageView.frame.origin.x,
                y: yPositionCondition + 50,
                width: imageView.frame.width,
                height: imageView.frame.height
            )
            storedAnnotations.forEach { (annotation) in
                if storedPDFPage.annotations.contains(annotation) {
                    storedPDFPage.removeAnnotation(annotation)
                    storedAnnotations.removeAll(where: {$0==annotation})
                }
            }
            
            let stamp = ImageStampAnnotation(with: imageView.image, forBounds: stampBound, withProperties: nil)
            view.currentPage?.addAnnotation(stamp)
            storedAnnotations.append(stamp)
            
            imageView.image = nil
            imageView.isUserInteractionEnabled = false
        }
        
    }
}
