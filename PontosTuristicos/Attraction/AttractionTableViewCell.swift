//
//  AttractionTableViewCell.swift
//  PontosTuristicos
//
//  Created by Satoru Kishi on 27/01/2019.
//  Copyright © 2019 Satoru Kishi. All rights reserved.
//

import UIKit

class AttractionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
