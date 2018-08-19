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
    
    var film : Film!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        // Título de la cabecera
        setTitleToHeader(episode: self.film.episode)
        
        // Configuración del Zoom
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0
        
        // Añadir imagen a la imageView
        self.image.image = self.film.image
    }
    
    func setTitleToHeader(episode: Int) {
        switch episode {
        case 1:
            self.title = "Episode I"
        case 2:
            self.title = "Episode II"
        case 3:
            self.title = "Episode III"
        case 4:
            self.title = "Episode IV"
        case 5:
            self.title = "Episode V"
        case 6:
            self.title = "Episode VI"
        case 7:
            self.title = "Episode VII"
        case 8:
            self.title = "Episode VIII"
        case 9:
            self.title = "Episode IX"
        default:
            self.title = "Cover"
        }
    }
    
    
    // MARK: - UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.image
    }

}
