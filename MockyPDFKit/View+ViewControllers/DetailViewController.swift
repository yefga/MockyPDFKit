//
//  DetailViewController.swift
//  MockyPDFKit
//
//  Created by Yefga on 01/08/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit
import PDFKit

final class DetailViewModel {
    
    let item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    func setupPDF(onComplete: @escaping (PDFDocument) -> ()) {
        
        if let url = URL(string: item.file), let pdfDocument = PDFDocument(url: url) {
            onComplete(pdfDocument)
        }
    }
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    private let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(toInsertImage(_:)))
    
    let viewModel: DetailViewModel
    
    
    fileprivate var image: UIImage? {
        didSet {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = image
            self.imageView.isHidden = image == nil
        }
    }
    
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupTitle()
        setupNavigation()
        setupPDFView()
        setupImageView()
    }
    
}

fileprivate extension DetailViewController {
    
    func setupTitle() {
        self.title = viewModel.item.name
    }
    
    func setupPDFView() {
        indicatorView.startAnimating()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let `self` = self else {return}
            
            self.viewModel.setupPDF { (document) in
                self.pdfView.displayMode = .singlePageContinuous
                self.pdfView.autoScales = true
                self.pdfView.displayDirection = .vertical
                self.pdfView.document = document
                self.indicatorView.stopAnimating()
                self.rightBarButtonItem.isEnabled = true
            }
        }
    }
    
    func setupNavigation() {
        self.rightBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func toInsertImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        
        self.present(imagePicker, animated: true)
    }
    
    func setupImageView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(toDragDrop(sender:)))
        imageView.addGestureRecognizer(panGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func toDragDrop(sender: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(imageView)
        let translation = sender.translation(in: self.view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
