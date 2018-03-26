//
//  TiempoFacade.swift
//  MPCRevisited
//
//  Created by cedest on 9/3/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation



class TiempoFacade{
    func insert(t: Double, size: Int, partSize: Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //let selectedDate = dateFormatter.string(from: self.startDate.date)
        var databasePath = NSString()
        //let filemgr = NSFileManager.defaultManager()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        //if !filemgr.fileExistsAtPath(databasePath as String) {
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var insertSQL = "INSERT INTO TIEMPO(TIEMPO, SIZE,PARTSIZE)"
            insertSQL += " VALUES  ('\(t)','\(size)','\(partSize)')"
            
            print("Tiempo: \(t), size: \(size), tamaño parte\(partSize)")
            
            
            //insertSQL += " VALUES ('\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)')"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                print("HOWEVER")
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué a tabla tiempo")
                
                let antes = UserDefaults.standard.integer(forKey: "n")
                UserDefaults.standard.set(antes+1, forKey: "n")
                UserDefaults.standard.synchronize()
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    
    func getAll()->String{
        var devolver = ""
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let querySQL = "SELECT TIEMPO, SIZE, PARTSIZE FROM TIEMPO"
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let a = result!.double(forColumnIndex: 0)
                    let b = result!.double(forColumnIndex: 1)
                    let c = result!.double(forColumnIndex: 2)
                    devolver += "\(a), \(b), \(c) \n"
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    
    func borrarTabla(){
        
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "DELETE FROM TIEMPO;"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                //print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("borrado")
            }
            contactDB.close()
        }
        else {
            //print("Error: \(contactDB.lastErrorMessage())")
        }
    
    }
    
   // CREATE TABLE ENTREGA(PARTES INTEGER, PARTESTOTALES INTEGER, SIZE INTEGER, PARTSIZE INTEGER, PORCENTAJE REAL);"
    func insert2(p1: Int, pTotales: Int, size: Int, partSize: Int, t1: Double, t2: Double, t3: Double, t4: Double, t5: Double, t6: Double, t7: Double, t8: Double){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //let selectedDate = dateFormatter.string(from: self.startDate.date)
        var databasePath = NSString()
        //let filemgr = NSFileManager.defaultManager()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        //if !filemgr.fileExistsAtPath(databasePath as String) {
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var insertSQL = "INSERT INTO ENTREGA(PARTES, PARTESTOTALES, SIZE, PARTSIZE, PORCENTAJE, TIEMPOENCUENTRO , TIEMPOHANDSHAKE, TIEMPOCONEXION, TIEMPOCABECERA, TIEMPOINICIOMENSAJE, TIEMPOFINMENSAJE , TIEMPODESCONEXION, TIEMPODB1)"
            insertSQL += " VALUES  (\(p1),\(pTotales),\(size),\(partSize), \(Double((p1 * 100)/pTotales)) , \(t1), \(t2), \(t3), \(t4), \(t5), \(t6), \(t7), \(t8))"
            
            
            //insertSQL += " VALUES ('\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)')"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                print("HOWEVER")
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué a tabla entrega")
                let antes = UserDefaults.standard.integer(forKey: "n")
                UserDefaults.standard.set(antes+1, forKey: "n")
                UserDefaults.standard.synchronize()
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    // CREATE TABLE ENTREGA(PARTES INTEGER, PARTESTOTALES INTEGER, SIZE INTEGER, PARTSIZE INTEGER, PORCENTAJE REAL);"
    func getAllEntregas()->String{
        var devolver = "partes, parteTotales, fileSize, partSize, porcentajeEntrega, tiempoEncuentro, tiempoHandShake, tiempoConexion, tiempoCabecera, tiempoInicioMensaje, tiempoFinMensaje, tiempoDesconexión, tiempoDB1, tiempoDB2  \n"
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            
            //" CREATE TABLE ENTREGA(PARTES INTEGER, PARTESTOTALES INTEGER, SIZE INTEGER, PARTSIZE INTEGER, PORCENTAJE REAL, TIEMPOENCUENTRO REAL, TIEMPOHANDSHAKE REAL, TIEMPOCONEXION REAL, TIEMPOCABECERA REAL, TIEMPOINICIOMENSAJE REAL, TIEMPOFINMENSAJE REAL, TIEMPODESCONEXION, TIEMPODB1 REAL, TIEMPODB2 REAL);"
            let querySQL = "SELECT PARTES, PARTESTOTALES, SIZE, PARTSIZE, PORCENTAJE, TIEMPOENCUENTRO, TIEMPOHANDSHAKE, TIEMPOCONEXION, TIEMPOCABECERA, TIEMPOINICIOMENSAJE, TIEMPOFINMENSAJE, TIEMPODESCONEXION, TIEMPODB1, TIEMPODB2   FROM ENTREGA"
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let a = result!.double(forColumnIndex: 0)
                    let b = result!.double(forColumnIndex: 1)
                    let c = result!.double(forColumnIndex: 2)
                    let d = result!.double(forColumnIndex: 3)
                    let e = result!.double(forColumnIndex: 4)
                    let f = result!.double(forColumnIndex: 5)
                    let g = result!.double(forColumnIndex: 6)
                    let h = result!.double(forColumnIndex: 7)
                    let i = result!.double(forColumnIndex: 8)
                    let j = result!.double(forColumnIndex: 9)
                    let k = result!.double(forColumnIndex: 10)
                    let l = result!.double(forColumnIndex: 11)
                    let m = result!.double(forColumnIndex: 12)
                    let n = result!.double(forColumnIndex: 13)
                    devolver += "\(a), \(b), \(c), \(d), \(e), \(f), \(g), \(h), \(i), \(j), \(k), \(l), \(m), \(n)   \n"
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    
    func borrarTablaEntrega(){
        
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "DELETE FROM ENTREGA;"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                //print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("borrado")
            }
            contactDB.close()
        }
        else {
            //print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }
    
    
    
    
    
    
    
    
    func insertHandShake(t1: Double, t2: Double, partSize: Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //let selectedDate = dateFormatter.string(from: self.startDate.date)
        var databasePath = NSString()
        //let filemgr = NSFileManager.defaultManager()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        //if !filemgr.fileExistsAtPath(databasePath as String) {
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        //CREATE TABLE HANDSHAKE(TIEMPOENCUENTRO REAL, TIEMPOHANDSHAKE REAL, SIZE INTEGER, PARTSIZE INTEGER)
        if (contactDB.open()) {
            var insertSQL = "INSERT INTO HANDSHAKE(TIEMPOENCUENTRO, TIEMPOHANDSHAKE, PARTSIZE)"
            insertSQL += " VALUES  (\(t1), \(t2), \(partSize))"
            
            
            //insertSQL += " VALUES ('\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)')"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                print("HOWEVER")
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué a tabla handShake")
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    
    
    
    func getAllHandShake()->String{
        var devolver = "tiempoEncuentro, tiempoHandShake, partSize, fileSize \n"
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        //CREATE TABLE HANDSHAKE(TIEMPOENCUENTRO REAL, TIEMPOHANDSHAKE REAL, SIZE INTEGER, PARTSIZE INTEGER);"
        if (contactDB.open()) {
            let querySQL = "SELECT TIEMPOENCUENTRO, TIEMPOHANDSHAKE, PARTSIZE  FROM HANDSHAKE"
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let a = result!.double(forColumnIndex: 0)
                    let b = result!.double(forColumnIndex: 1)
                    let c = result!.int(forColumnIndex: 2)
                    devolver += "\(a),\(b),\(c) \n"
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    func borrarTablaHandShake(){
        
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "DELETE FROM HANDSHAKE;"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                //print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("borrado")
            }
            contactDB.close()
        }
        else {
            //print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }

}
