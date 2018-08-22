//
//  PlanetCell.swift
//  StarWarsExample
//
//  Created by CRISTIAN ESPES on 21/8/18.
//  Copyright © 2018 CRISTIAN ESPES. All rights reserved.
//

import UIKit

class PlanetCell: UITableViewCell {
    
    @IBOutlet weak var planetImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
