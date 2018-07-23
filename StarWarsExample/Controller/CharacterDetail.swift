//
//  CharacterDetail.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 21/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class CharacterDetail: UIViewController {
    
    // Contenido del film
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var nameText: UILabel!
    @IBOutlet var genderText: UILabel!
    @IBOutlet var birthText: UILabel!
    @IBOutlet var heightText: UILabel!
    @IBOutlet var massText: UILabel!
    @IBOutlet var hairText: UILabel!
    @IBOutlet var skinText: UILabel!
    @IBOutlet var eyeText: UILabel!
    
    var person : Person!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Actualizamos los objetos de la vista
        self.characterImageView.image = self.person.image
        self.nameText.text = self.person.name
        self.genderText.text = self.person.gender
        self.birthText.text = self.person.birth_year
        self.heightText.text = self.person.height
        self.massText.text = self.person.mass
        self.hairText.text = self.person.hair_color
        self.skinText.text = self.person.skin_color
        self.eyeText.text = self.person.eye_color
        
        // Título de la cabecera
        self.title = self.person.name
        
    }
    
    // Ocultar menú superior
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}