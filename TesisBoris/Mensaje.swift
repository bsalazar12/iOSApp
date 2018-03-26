//
//  Mensajes.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


//entidad mensaje
import Foundation

class Mensaje: NSObject{
    var origen: String = ""
    var destino: String = ""
    var mensaje: String = ""
    var fecha: String = ""
    var mensajeId: String = ""
    var MensajeBytes: Data = Data()
    var totalPartes = 0
    var partes: [Parte] = []
    var isImage: Bool = false
    
    
    
    var totalSize: Int = 0
    var partSize: Int = 0
    
    override init(){}
    
    
    
    init(o: String, d: String, m: String, f: String, mId: String ){
        self.origen = o
        self.destino = d
        self.mensaje = m
        self.fecha = f
        self.mensajeId = mId
    }
    
    init(o: String, d: String, m: Data, f: String, mId: String, isImage: Bool = false){
        self.origen = o
        self.destino = d
        self.MensajeBytes = m
        self.fecha = f
        self.mensajeId = mId
        self.isImage = isImage
    }
    
    init(o: String, d: String, f: String, mId: String, isImage: Bool = false, partes: [Parte], pTotales: Int){
        self.origen = o
        self.destino = d
        self.fecha = f
        self.mensajeId = mId
        self.isImage = isImage
        self.partes = partes
        self.totalPartes = pTotales
    }

}
