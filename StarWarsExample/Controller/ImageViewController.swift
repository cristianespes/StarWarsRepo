//
//  ImageViewController.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 16/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var image: UIImageView!
    var getImage : UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        // Título de la cabecera
        //self.title = "Cover"
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0

       //self.image = self.receivedImage
        self.image.image = self.getImage.image
    }
    
    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }

}
