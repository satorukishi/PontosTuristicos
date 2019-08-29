//
//  Attraction.swift
//  PontosTuristicos
//
//  Created by Satoru Kishi on 08/03/2019.
//  Copyright © 2019 Satoru Kishi. All rights reserved.
//

import Foundation

class Attraction {
    var title : String = ""   // nome do local
    var address : String = "" // endereço
    
    // construtor com parametros
    init(title: String, address: String) {
        self.title = title
        self.address = address
    }
    
    init() {
        
    }
}
