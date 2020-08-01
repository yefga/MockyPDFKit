//
//  ImageStampAnnotation.swift
//  MockyPDFKit
//
//  Created by Yefga on 01/08/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit
import PDFKit

/// Not really sure if it's the best solution since we should dealing with CGPoint 😂,
/// I'm really new at this Framework

class ImageStampAnnotation: PDFAnnotation {
        
    var image: UIImage!
    
    // A custom init that sets the type to Stamp on default and assigns our Image variable
    init(with image: UIImage!, forBounds bounds: CGRect, withProperties properties: [AnyHashable : Any]?) {
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        
        // Get the CGImage of our image
        guard let cgImage = self.image.cgImage else { return }
        
        // Draw our CGImage in the context of our PDFAnnotation bounds
        context.draw(cgImage, in: self.bounds)
        
    }
}

