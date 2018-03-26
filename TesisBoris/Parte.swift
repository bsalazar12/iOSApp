//
//  Parte.swift
//  MPCRevisited
//
//  Created by cedest on 8/8/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//


//Entidad parte 

import Foundation


class Parte {
    var data = Data()
    var nParte = -1
    var prioridad = -1
    var fecha = ""
    var hash = ""
    
    var packetSize: Int = 0
    
    init(){}
    
    init(d: Data, nParte: Int, p: Int, f: String){
        self.data = d
        self.nParte = nParte
        self.prioridad = p
        self.fecha = f
    }
    
    init(d: Data, nParte: Int, p: Int, f: String, h: String){
        self.data = d
        self.nParte = nParte
        self.prioridad = p
        self.fecha = f
        self.hash = h
    }
    
    
}
