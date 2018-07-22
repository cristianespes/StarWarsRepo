//
//  CharactersTableView.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 20/7/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class CharactersTableView: UIViewController, UITableViewDataSource {
    
    
    var people : [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var person = Person(name: "Lucas", birth_year: "1991", gender: "masculi", image: #imageLiteral(resourceName: "film1"))
        people.append(person)
        
        person = Person(name: "Maria", birth_year: "1995", gender: "femenino", image: #imageLiteral(resourceName: "film5"))
        people.append(person)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = self.people[indexPath.row]
        let cellID = "CharacterCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CharacterCell
        cell.thumbnailImageView.image = person.image
        cell.nameLabel.text = person.name
        cell.genderLabel.text = person.gender
        cell.birthLabel.text = person.birth_year
        
        cell.thumbnailImageView.layer.cornerRadius = 10.0
        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }

}
