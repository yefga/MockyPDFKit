//
//  DetailViewController.swift
//  MockyPDFKit
//
//  Created by Yefga on 01/08/20.
//  Copyright © 2020 Yefga. All rights reserved.
//

import UIKit
import PDFKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    private let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toInsertImage(_:)))
    
    
    fileprivate var image: UIImage? {
        didSet {
            self.imageView.contentMode = .center
            self.imageView.image = image
            self.imageView.isHidden = image == nil
        }
    }
    
    let viewModel: DetailViewModel
    
   
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
                self.pdfView.displayDirection = .horizontal
                self.pdfView.document = document
                self.pdfView.minScaleFactor = 0.1
                self.pdfView.maxScaleFactor = 5
                self.pdfView.usePageViewController(true, withViewOptions: nil)
                
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
        self.imageView.isUserInteractionEnabled = true
        self.imageView.image = UIImage(named: "pikachu")
    }
    
    
    func setupImageView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(toDragDrop(sender:)))
        imageView.addGestureRecognizer(panGesture)
    }
    
    @objc func toDragDrop(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .changed:
                let translation = sender.translation(in: view)
                imageView.center = CGPoint(x: imageView.center.x + translation.x,
                                        y: imageView.center.y + translation.y)
                sender.setTranslation(.zero, in: view)
                
            case .ended:
                showAlert()

            default:
                break
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Add Stamp", message: "Do you want to add stamp in this location?", preferredStyle: .alert)
        
    
        let okAction = UIAlertAction(title: "YES", style: .default) { _ in
            self.viewModel.updateAnnotation(from: self.pdfView, with: self.imageView)
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
