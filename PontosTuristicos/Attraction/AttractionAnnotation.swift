//
//  AttractionAnnotation.swift
//  PontosTuristicos
//
//  Created by Satoru Kishi on 26/08/19.
//  Copyright © 2019 Satoru Kishi. All rights reserved.
//

import Foundation
import MapKit

class AttractionAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    //Criando construtor que solicita a coordenada da annotation
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
