//
//  Varios.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


//clase con funciones varias para fácil acceso
//la más importante es el createChunks
import Foundation
import CryptoSwift

class Varios{
    func crearBaseDeDatos(){
        print("Crear DB")
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
        //"CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT)"
        if (contactDB.open()) {
            
            var sql_stmt = ""//DROP TABLE IF EXISTS MENSAJES;"
            sql_stmt += " CREATE TABLE ENTREGA(PARTES INTEGER, PARTESTOTALES INTEGER, SIZE INTEGER, PARTSIZE INTEGER, PORCENTAJE REAL, TIEMPOENCUENTRO REAL, TIEMPOHANDSHAKE REAL, TIEMPOCONEXION REAL, TIEMPOCABECERA REAL, TIEMPOINICIOMENSAJE REAL, TIEMPOFINMENSAJE REAL, TIEMPODESCONEXION, TIEMPODB1 REAL, TIEMPODB2 REAL);" //tabla pruebas
            
            sql_stmt += " CREATE TABLE HANDSHAKE(TIEMPOENCUENTRO REAL, TIEMPOHANDSHAKE REAL, SIZE INTEGER, PARTSIZE INTEGER);"
            
            sql_stmt += "CREATE TABLE BANDEJA(ORIGEN TEXT, DESTINO TEXT, MENSAJE TEXT, IMAGEN BLOB, FECHA DATETIME, MENSAJEID TEXT, ESIMAGEN BOOL); "
            
                        
            sql_stmt += " CREATE TABLE MENSAJE(ORIGEN TEXT, DESTINO TEXT, FECHA DATETIME, MENSAJEID TEXT, PARTES_TOTALES INTEGER, ESIMAGEN BOOL, TOTALSIZE INTEGER, PARTSIZE INTEGER);"
            sql_stmt += " CREATE TABLE PARTES(MENSAJEID TEXT, NUMERO_PARTE INTEGER, BYTES BLOB,PRIORIDAD INTEGER, FECHA DATETIME, HASH TEXT);"
            
            sql_stmt += " CREATE TABLE TIEMPO(TIEMPO REAL, SIZE INTEGER, PARTSIZE INTEGER, MOVIMIENTO BOOL);" //tabla pruebas
            
            
            
            if !(contactDB.executeStatements(sql_stmt)) {
                print("Error: \(contactDB.lastErrorMessage())")
            }else{
                print("It worked!")
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        //} //fin si existe el archivo
    }
    
    //Funcion para tener color de fácil acceso, solo es un tema visual
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()//hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    
    //consigue la configuración del telefono
    func miNumero()->String{
        return UserDefaults.standard.string(forKey: "numero")!
    }
    
    //consigue la configuración del telefono 
    func miSize()->Int{
        return UserDefaults.standard.integer(forKey: "size")
    }
    
    
    func createChunks(forData: Data)->[Data] {
        
        //por defecto parte el mensaje en 3, en caso que no haya otra configuración
        //guardada
        var size = forData.count / 3
        if Int(Varios().miSize()) != 0 {
            //convierte la configuracion guardada en kilos(bytes)
            size = Int(Varios().miSize()) * 1000
        }
        var trozos: [Data] = []
        forData.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            //puntero a nivel de bits
            let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
            //de cuanto será los chunks
            let uploadChunkSize = size
            //total del tamaño en bytes para realizar el cálculo
            let totalSize = forData.count
            //contador
            var offset = 0
            while offset < totalSize {
                
                //asigna un tamaño de chunk
                //en la práctica, solo es el último chunk el que tiene otro tamaño
                let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                //crea el chunk de data
                let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                //guarda el trozo en bits
                trozos.append(chunk)
                //actualiza el contador en bits
                offset += chunkSize
            }
        }
        return trozos
    }
    
    //funcion md5
    func md5(s: String)->String{
        let hash = s.md5()
        return hash
    }
}
