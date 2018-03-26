//
//  MensajeFacade.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import Foundation

class MensajeFacade {
    
    func findAllForList()->[Mensaje]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        let miNumero = UserDefaults.standard.string(forKey: "numero")
        var devolver = [Mensaje]()
        
        
        
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, FECHA, MENSAJEID FROM BANDEJA"
            querySQL += " WHERE DESTINO = '\(miNumero!)'"
            querySQL += " ORDER BY FECHA DESC"
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let f = result!.string(forColumnIndex: 2)
                    let mId = result!.string(forColumnIndex: 3)
                    
                    let mensaje = Mensaje()
                    
                    mensaje.origen = o!
                    mensaje.destino = d!
                    mensaje.fecha = f!
                    mensaje.mensajeId = mId!
                    
                    
                    
                    
                    devolver.append(mensaje)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func findAll()->[Mensaje]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        let miNumero = UserDefaults.standard.string(forKey: "numero")
        var devolver = [Mensaje]()
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, MENSAJE, FECHA, MENSAJEID, IMAGEN, ESIMAGEN FROM BANDEJA"
            querySQL += " WHERE DESTINO = '\(miNumero!)'"
            querySQL += " ORDER BY FECHA DESC"
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let m = result!.string(forColumnIndex: 2)
                    let f = result!.string(forColumnIndex: 3)
                    let mId = result!.string(forColumnIndex: 4)
                    
                    let imagen = result!.data(forColumnIndex: 5)
                    var mensaje = Mensaje()
                    if m != nil {
                        mensaje = Mensaje( o: o!, d: d!, m: m!, f: f!, mId: mId!)
                        
                    }else{
                        mensaje = Mensaje(o: o!, d: d!, m: imagen!, f: f!, mId: mId!, isImage: true)
                    }
                    
                    
                    devolver.append(mensaje)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func findAllMessages()->[Mensaje]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver = [Mensaje]()
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, MENSAJE, FECHA, MENSAJEID FROM BANDEJA"
            querySQL += " ORDER BY FECHA DESC"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let m = result!.string(forColumnIndex: 2)
                    let f = result!.string(forColumnIndex: 3)
                    let mId = result!.string(forColumnIndex: 4)
                    let project = Mensaje( o: o!, d: d!, m: m!, f: f!, mId: mId!)
                    devolver.append(project)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    
    func findAllMessages2()->[Mensaje]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver = [Mensaje]()
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, FECHA, MENSAJEID, PARTES_TOTALES, ESIMAGEN, TOTALSIZE, PARTSIZE FROM MENSAJE"
            querySQL += " ORDER BY RANDOM()"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let f = result!.string(forColumnIndex: 2)
                    let mId = result!.string(forColumnIndex: 3)
                    let pTotales = result!.int(forColumnIndex: 4)
                    let esImagen = result!.bool(forColumnIndex: 5)
                    
                    let ts = result!.int(forColumnIndex: 6)
                    let ps = result!.int(forColumnIndex: 7)
                    
                    let partes = self.findAllParts(mId: mId!, random: true)
                    
                    
                    
                    let mensaje = Mensaje(o: o!, d: d!, f: f!, mId: mId!, isImage: esImagen, partes: partes, pTotales: Int(pTotales))
                    
                    
                    mensaje.totalSize = Int(ts)
                    mensaje.partSize = Int(ps)
                    
                    
                    devolver.append(mensaje)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func findAllParts(mId: String, random: Bool = false)->[Parte]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver: [Parte] = []
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        if (contactDB.open()) {
            var querySQL = "SELECT MENSAJEID, NUMERO_PARTE, BYTES, PRIORIDAD, FECHA, HASH FROM PARTES"
            querySQL += " WHERE MENSAJEID = '\(mId)' "
            
            if random {
                querySQL += " ORDER BY PRIORIDAD, RANDOM()"
            }else {
                querySQL += " ORDER BY NUMERO_PARTE ASC"
            }
            
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    _ = result!.string(forColumnIndex: 0)
                    let nP = result!.int(forColumnIndex: 1)
                    let bytes = result!.data(forColumnIndex: 2)
                    let p = result!.int(forColumnIndex: 3)
                    let f = result!.string(forColumnIndex: 4)
                    let h = result!.string(forColumnIndex: 5)
                    let parte = Parte(d: bytes!, nParte: Int(nP), p: Int(p), f: f!, h: h!)
                    print("mirar")
                    print(bytes?.count)
                    devolver.append(parte)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    
    
    func findMessageByIdAndNp(mId: String, ids: String)->[Mensaje]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver = [Mensaje]()
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, FECHA, MENSAJEID, PARTES_TOTALES, ESIMAGEN FROM MENSAJE"
            querySQL += " WHERE MENSAJEID = '\(mId)'"
            querySQL += " ORDER BY FECHA DESC"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let f = result!.string(forColumnIndex: 2)
                    let mId = result!.string(forColumnIndex: 3)
                    let pTotales = result!.int(forColumnIndex: 4)
                    let esImagen = result!.bool(forColumnIndex: 5)
                    
                    print("es Imagen")
                    print(esImagen)
                    
                    
                    let partes = self.findAllPartsByIdAndNP(mId: mId!, ids: ids)
                    
                    
                    
                    let mensaje = Mensaje(o: o!, d: d!, f: f!, mId: mId!, isImage: esImagen, partes: partes, pTotales: Int(pTotales))
                    
                    devolver.append(mensaje)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func findAllPartsByIdAndNP(mId: String, ids: String, random: Bool = true)->[Parte]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver: [Parte] = []
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        if (contactDB.open()) {
            var querySQL = "SELECT MENSAJEID, NUMERO_PARTE, BYTES, PRIORIDAD, FECHA, HASH FROM PARTES"
            querySQL += " WHERE MENSAJEID = '\(mId)' AND NUMERO_PARTE NOT IN (\(ids)) "
            
            if random {
                querySQL += " ORDER BY PRIORIDAD, RANDOM()"
            }else {
                querySQL += " ORDER BY NUMERO_PARTE ASC"
            }
            
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    _ = result!.string(forColumnIndex: 0)
                    let nP = result!.int(forColumnIndex: 1)
                    let bytes = result!.data(forColumnIndex: 2)
                    let p = result!.int(forColumnIndex: 3)
                    let f = result!.string(forColumnIndex: 4)
                    let h = result!.string(forColumnIndex: 5)
                    
                    let parte = Parte(d: bytes!, nParte: Int(nP), p: Int(p), f: f!,h: h!)
                    
                    devolver.append(parte)
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    func exists(mId: String, nP: Int)->Bool{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver = false
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        if (contactDB.open()) {
            var querySQL = "SELECT MENSAJEID, NUMERO_PARTE FROM PARTES"
            querySQL += " WHERE MENSAJEID = '\(mId)' AND NUMERO_PARTE = \(nP)"
            
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    devolver = true
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func existsInBandeja(mId: String)->Bool{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver = false
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        if (contactDB.open()) {
            var querySQL = "SELECT MENSAJEID FROM BANDEJA"
            querySQL += " WHERE MENSAJEID = '\(mId)'"
            
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    devolver = true
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    
    func delete(id: String){
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "DELETE FROM BANDEJA WHERE MENSAJEID = '\(id)'"
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
    
    func insert(m: Mensaje){
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
            var insertSQL = "INSERT INTO BANDEJA(ORIGEN, DESTINO,MENSAJE,FECHA,MENSAJEID)"
            insertSQL += " SELECT '\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)'"
            insertSQL += " WHERE NOT EXISTS(SELECT 1 FROM BANDEJA WHERE MENSAJEID = '\(m.mensajeId)');"
            
            
            //insertSQL += " VALUES ('\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)')"
            let result = contactDB.executeUpdate(insertSQL,
                                                  withArgumentsIn: [])
            if !result {
                print("HOWEVER")
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué! omg")
                
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
    
    func insert2(m: Mensaje){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var databasePath = NSString()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            //seteo del objeto
            var trozosMensaje: [Data] = []
            if m.isImage{
                trozosMensaje = Varios().createChunks(forData: m.MensajeBytes)
            }
            //bol si es imagen
            var bol = 0
            if m.isImage {
                bol = 1
            }
            
            //query de INSERT
            var insertSQL = "INSERT INTO MENSAJE(ORIGEN, DESTINO,FECHA,MENSAJEID, PARTES_TOTALES, ESIMAGEN, TOTALSIZE, PARTSIZE)"
            insertSQL += " SELECT '\(m.origen)','\(m.destino)','\(m.fecha)','\(m.mensajeId)', \(m.totalPartes), \(bol), \(m.totalSize) , \(m.partSize)  "
            insertSQL += " WHERE NOT EXISTS(SELECT 1 FROM MENSAJE WHERE MENSAJEID = '\(m.mensajeId)');"
            
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué mensaje!")
                if m.isImage {
                    //por cada parte del mensaje, se hace otro insert a DB
                    for parte in m.partes{
                        print("agrego parte")
                        print(parte.data.count)
                        self.insertPartes(mId: m.mensajeId, nP: parte.nParte, bytes: parte.data, p: parte.prioridad)
                    }
                }
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
    
        
    func insertPartes(mId: String, nP: Int, bytes: Data, p: Int ){
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
            //seteo del objeto
            //genera un codigo md5 para los bytes del trozo
            let hash = Varios().md5(s: "\(bytes)")
            //query insert, tambien va el md5
            var insertSQL = "INSERT INTO PARTES(MENSAJEID, NUMERO_PARTE, BYTES, PRIORIDAD, FECHA, hash)"
            insertSQL += " SELECT '\(mId)',\(nP), ?,'\(p)', DATETIME('now'), '\(hash)'"
            insertSQL += " WHERE NOT EXISTS(SELECT 1 FROM PARTES WHERE MENSAJEID = '\(mId)' AND NUMERO_PARTE = \(nP));"
            let result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [bytes])
            //let result = contactDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué parte!")
                //actualiza el identificador del mensaje, el contador intenro
                //con el fin de tener identificadores unicos para cada mensaje
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
    
    func findById(id: String)->Mensaje{
        var devolver = Mensaje()
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, MENSAJE, FECHA, MENSAJEID, ESIMAGEN, IMAGEN FROM BANDEJA"
            querySQL += " WHERE MENSAJEID = '\(id)'"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    print("Encontré mensaje con id")
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    _ = result!.string(forColumnIndex: 2)
                    let f = result!.string(forColumnIndex: 3)
                    let mId = result!.string(forColumnIndex: 4)
                    
                    _ = result!.bool(forColumnIndex: 5)
                    let imagen = result!.data(forColumnIndex: 6)
                    let partes_totales = result!.int(forColumnIndex: 7)
                    
                    var mensaje = Mensaje()
                    mensaje = Mensaje(o: o!, d: d!, m: imagen!, f: f!, mId: mId!, isImage: true)
                    mensaje.totalPartes = Int(partes_totales)
                    
                    devolver = mensaje
                }//fin while

            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func partesTotalesByMensaje(id: String)->Int{
        var devolver = 0
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT PARTES_TOTALES, MENSAJEID  FROM MENSAJE"
            querySQL += " WHERE MENSAJEID = '\(id)'"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    print("ecnontre mensaje con id")
                    let n = result!.int(forColumnIndex: 0)
                
                    devolver = Int(n)
                }//fin while
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
                return devolver
    }
    
    func deleteAll(){
        self.deletePartes()
        self.deleteMensajes()
        self.deleteBandeja()
        
    }
    
    func deletePartes(){
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "DELETE FROM PARTES;"
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
    
    func deleteMensajes(){
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = " DELETE FROM MENSAJE"
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
    
    func deleteBandeja(){
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "DELETE FROM BANDEJA"
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
    
    func updatePriority(mId: String, nP: Int){
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            let insertSQL = "UPDATE PARTES SET PRIORIDAD = PRIORIDAD + 1  WHERE MENDAJEID = '\(mId)' AND NUMERO_PARTE = \(nP)"
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
    
    
    func insertarEnBandeja(m: Mensaje){
        
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
            
            var bolString = 0
            
            if m.isImage {
                bolString = 1
            }
            
            var insertSQL = ""
            m.isImage = true
            
            
            var result: Bool? = false
            
            if m.isImage{
                insertSQL = "INSERT INTO BANDEJA(ORIGEN, DESTINO,IMAGEN,FECHA, MENSAJEID, ESIMAGEN)"
                insertSQL += " SELECT '\(m.origen)','\(m.destino)', ?,'\(m.fecha)','\(m.mensajeId)', '\(bolString)'"
                insertSQL += " WHERE NOT EXISTS(SELECT 1 FROM BANDEJA WHERE MENSAJEID = '\(m.mensajeId)');"
                
                
                print("INSERTAR ESTOS BYTES")
                print(m.MensajeBytes)
                
                result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [m.MensajeBytes])
                
            }else{
                insertSQL = "INSERT INTO BANDEJA(ORIGEN, DESTINO,MENSAJE,FECHA,MENSAJEID, ESIMAGEN)"
                insertSQL += " SELECT '\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)', '\(bolString)'"
                insertSQL += " WHERE NOT EXISTS(SELECT 1 FROM BANDEJA WHERE MENSAJEID = '\(m.mensajeId)');"
                
                result = contactDB.executeUpdate(insertSQL, withArgumentsIn: [])
                
            }
            
            //insertSQL += " VALUES ('\(m.origen)','\(m.destino)','\(m.mensaje)', '\(m.fecha)','\(m.mensajeId)')"
            
            if !result! {
                print("HOWEVER")
                print("Error: \(contactDB.lastErrorMessage())")
                
            } else {//si agregó bien
                print("Agregué a bandeja")
                
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
    
    
    
    
    
    
    func comprobarMisMensajes(){
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        let miNumero = UserDefaults.standard.string(forKey: "numero")
        var devolver: [Mensaje] = []
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, FECHA, MENSAJEID, PARTES_TOTALES, ESIMAGEN FROM MENSAJE"
            querySQL += " WHERE DESTINO = '\(miNumero!)'"
            querySQL += " ORDER BY FECHA DESC"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let f = result!.string(forColumnIndex: 2)
                    let mId = result!.string(forColumnIndex: 3)
                    let pTotales = result!.int(forColumnIndex: 4)
                    let esImagen = result!.bool(forColumnIndex: 5)
                    
                    
                    let partes = self.findAllParts(mId: mId!)
                    var todo = Data()
                    print("partes?")
                    print(pTotales)
                    print(partes.count)
                    for p in partes {
                        todo.append(contentsOf: p.data)
                    }
                    
                    
                    
                    let mensaje = Mensaje(o: o!, d: d!, f: f!, mId: mId!, isImage: esImagen, partes: partes, pTotales: Int(pTotales))
                    
                    if mensaje.totalPartes == mensaje.partes.count {
                        print("tengo todas las partes")
                        devolver.append(mensaje)
                    }
                    
                    
                    
                }//fin while
                
                for m in devolver{
                    
                    var dataFinal = Data()
                    print(m.partes.count)
                    for p in m.partes {
                        dataFinal.append(p.data)
                    }
                    print("DATAFINAL")
                    print(dataFinal.count)
                    m.MensajeBytes = dataFinal
                    
                    self.insertarEnBandeja(m: m)
                }
                
                
                
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    func comprobarMisMensajesById(mId: String)->[Int]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        let miNumero = UserDefaults.standard.string(forKey: "numero")
        var devolver: [Mensaje] = []
        var retornar: [Int] = []
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, FECHA, MENSAJEID, PARTES_TOTALES, ESIMAGEN FROM MENSAJE"
            querySQL += " WHERE DESTINO = '\(miNumero!)' AND MENSAJEID = '\(mId)'"
            querySQL += " ORDER BY FECHA DESC"
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                //reviso todos los mensajes que tengo en DB, aún incompletos
                while result?.next() == true{
                    let o = result!.string(forColumnIndex: 0)
                    let d = result!.string(forColumnIndex: 1)
                    let f = result!.string(forColumnIndex: 2)
                    let mId = result!.string(forColumnIndex: 3)
                    let pTotales = result!.int(forColumnIndex: 4)
                    let esImagen = result!.bool(forColumnIndex: 5)
                    
                    
                    let partes = self.findAllParts(mId: mId!)
                    var todo = Data()
                    for p in partes {
                        todo.append(contentsOf: p.data)
                    }
                    
                    let mensaje = Mensaje(o: o!, d: d!, f: f!, mId: mId!, isImage: esImagen, partes: partes, pTotales: Int(pTotales))
                    
                    if mensaje.totalPartes == mensaje.partes.count {
                        print("tengo todas las partes")
                        devolver.append(mensaje)
                    }
                }//fin while
                
                //para cada mensaje que se encontró completo,
                //se guarda el mensaje en otra tabla
                var flag = true
                for m in devolver{
                    var dataFinal = Data()
                    for p in m.partes {
                        if flag{
                            retornar.append(p.data.count)
                            flag = false
                        }
                        dataFinal.append(p.data)
                    }
                    retornar.append(dataFinal.count)
                    m.MensajeBytes = dataFinal
                    //se guarda mensaje completo en otra tabla
                    //(la imagen está en bits de forma completa)
                    self.insertarEnBandeja(m: m)
                }
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        return retornar
    }
    
    func tengoTodasLasPartes(mId: String)->Bool{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        let miNumero = UserDefaults.standard.string(forKey: "numero")
        var devolver = false
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        if (contactDB.open()) {
            var querySQL = "SELECT ORIGEN, DESTINO, FECHA, MENSAJEID, PARTES_TOTALES, ESIMAGEN FROM MENSAJE"
            querySQL += " WHERE DESTINO = '\(miNumero!)' AND MENSAJEID = '\(mId)'"
            querySQL += " ORDER BY FECHA DESC"
            print(querySQL)
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    _ = result!.string(forColumnIndex: 0)
                    _ = result!.string(forColumnIndex: 1)
                    _ = result!.string(forColumnIndex: 2)
                    let mId = result!.string(forColumnIndex: 3)
                    let pTotales = result!.int(forColumnIndex: 4)
                    _ = result!.bool(forColumnIndex: 5)
                    
                    
                    let partes = self.cantidadPartes(mId: mId!)
                    print("ver")
                    print(pTotales)
                    print(partes[0])
                    if Int(pTotales) == partes[0] - 1 {
                        print("tengo todas las partes")
                        devolver = true
                    }
                    
                    
                    
                }//fin while
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        return devolver
    }
    
    
    func cantidadPartes(mId: String)->[Int]{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
        var devolver: [Int] = []
        var databasePath = NSString()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        databasePath = docsDir.appendingPathComponent("database.db") as NSString
        
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB == nil {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
        
        if (contactDB.open()) {
            
            
            let totalPartes = self.partesTotalesByMensaje(id: mId)
            
            var querySQL = "SELECT COUNT(*) FROM PARTES"
            querySQL += " WHERE MENSAJEID = '\(mId)'"
            
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let n = result?.int(forColumnIndex: 0)
                    
                    devolver = [Int(n!) + 1, totalPartes]
                }//fin while
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    func partesNumero(mId: String)->String{
        if UserDefaults.standard.string(forKey: "numero") == nil{
            UserDefaults.standard.set("", forKey: "numero")
            UserDefaults.standard.synchronize()
        }
        _ = UserDefaults.standard.string(forKey: "numero")
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
            
            _ = self.partesTotalesByMensaje(id: mId)
            
            var querySQL = "SELECT NUMERO_PARTE, MENSAJEID FROM PARTES"
            querySQL += " WHERE MENSAJEID = '\(mId)'"
            
            
            let result:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsIn: [])
            if (result == nil) {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                while result?.next() == true{
                    let n = result?.string(forColumnIndex: 0)
                    
                    devolver += "\(n!),"
                }//fin while
                if devolver.characters.count > 0 {
                    devolver = devolver.substring(to: devolver.index(before: devolver.endIndex))
                }
                
            }
            contactDB.close()
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        return devolver
    }
    
    
    
    


}
