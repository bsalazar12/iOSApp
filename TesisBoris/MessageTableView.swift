//
//  MessageTable.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

var selectedID = ""
class MessageTableView: UITableViewController, MPCManagerDelegate {
    var section = ["Recibidos", "Completados"]
    var lista = [Mensaje]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var hs : [String: Bool] = [:]
    
    
    var partesEnviar: [Mensaje] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Varios().crearBaseDeDatos()
        self.lista = MensajeFacade().findAll()
        
        
        if UserDefaults.standard.integer(forKey: "size") == 0{
            print("es cero")
            UserDefaults.standard.set(0, forKey: "size")
            UserDefaults.standard.synchronize()
        }
        
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleMPCReceivedDataWithNotification(_:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Varios().crearBaseDeDatos()
        
        //self.section = TaskFacade().findAllDates()
        self.lista = MensajeFacade().findAll()
        actualizarTabla()
    }
    
    func actualizarTabla(){
        self.tableView.reloadData()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1//self.section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lista.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wat", for: indexPath as IndexPath) as! CeldaMensaje
        cell.labelOrigen.text = self.lista[indexPath.row].origen
        cell.id = self.lista[indexPath.row].mensajeId
        cell.labelMensaje.text =  self.lista[indexPath.row].mensaje
        cell.labelOrigen.text = "De: \(self.lista[indexPath.row].origen)"
        let btn2 = MGSwipeButton(title: "Borrar", backgroundColor: UIColor.red, callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            MensajeFacade().delete(id: cell.id)
            var flag = false
            if self.tableView.numberOfRows(inSection: indexPath.section) <= 1 {
                flag = true
            }
            self.tableView.beginUpdates()
            //Set the row to remove from the tableView
            var tRemove:Array<NSIndexPath> = Array()
            let tIndexPath:NSIndexPath = NSIndexPath(row: indexPath.row, section: indexPath.section)
            tRemove.append(tIndexPath)
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            //Remove the deleted data from the datasource
            let tRemoveIndexSet:NSMutableIndexSet = NSMutableIndexSet()
            tRemoveIndexSet.add(indexPath.row)
            
            //llenar tabla de nuevo
            self.lista = MensajeFacade().findAll()
            //self.section = TaskFacade().findAllDates()
            //Remove the row from tableView
            
            self.tableView.deleteRows(at: tRemove as [IndexPath], with: .left)
            if flag {
                //borrar sección
                //self.tableView.deleteSections(indexSet as IndexSet, with: .fade)
            }
            self.tableView.endUpdates()
            //self.actualizarTabla()
            self.tableView.reloadData()
            return true
        })
        //configure right buttons
        cell.rightButtons = [btn2]//, btn3]
        cell.rightSwipeSettings.transition = MGSwipeTransition.drag
        cell.rightExpansion.buttonIndex = 0
        cell.rightExpansion.fillOnTrigger = true
        cell.rightExpansion.threshold = 1.6
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CeldaMensaje
        selectedID = cell.id
    }
    
    // MARK: MPCManagerDelegate method implementation
    
    func foundPeer() {
        for peer in appDelegate.mpcManager.foundPeers {
            if !appDelegate.mpcManager.session.connectedPeers.contains(peer){
                appDelegate.mpcManager.browser.invitePeer(peer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
            }
        }
    }
    
    
    func lostPeer() {
        
        if appDelegate.mpcManager.session.connectedPeers.count == 0{
            self.appDelegate.mpcManager.session.disconnect()
        }
        
        print("LO PERDEMOS")
    }
    
    func invitationWasReceived(_ fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to chat with you.", preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            self.appDelegate.mpcManager.invitationHandler(false, nil)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        /*
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }*/
        //crear sesión sin preguntar
        self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
    }
    
    
    
    func connectedWithPeer(_ peerID: MCPeerID) {
        
        
        for peer in appDelegate.mpcManager.session.connectedPeers {
            
            
            let allMessages = MensajeFacade().findAllMessages2()
            for mensaje in allMessages{
                for parte in mensaje.partes{
                    let encodedData = parte.data.base64EncodedString(options: .lineLength64Characters)
                    
                    
                    var bolString = "0"
                    if mensaje.isImage{
                        bolString = "1"
                    }
                    
                    print("peerID")
                    print(peerID)
                    
                    var messageDictionary: [String: String] = ["cabecera": "check"]
                    
                    messageDictionary["peerId"] =  "\(peerID)"
                    messageDictionary["numeroParte"] =  "\(parte.nParte)"
                    messageDictionary["mensajeId"] = mensaje.mensajeId
                    
                    if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                    }
                }
                
            }
            
            
        }
    }//fin función
    
    
    func connectedWithPeer15(_ peerID: MCPeerID) {
        
        
        for peer in appDelegate.mpcManager.session.connectedPeers {
            
            var messageDictionary: [String: String] = ["hs": "1"]
            if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                print("Estoy enviando handShake!")
                
                
            }
            
            let allMessages = MensajeFacade().findAllMessages2()
            for mensaje in allMessages{
                
                for parte in mensaje.partes{
                    
                    let encodedData = parte.data.base64EncodedString(options: .lineLength64Characters)
                    
                    
                    var bolString = "0"
                    if mensaje.isImage{
                        bolString = "1"
                    }
                    
                    var messageDictionary: [String: String] = ["origen": mensaje.origen]
                    messageDictionary["destino"] = mensaje.destino//["destino": ]
                    messageDictionary["mensaje"] =     encodedData
                    messageDictionary["numeroParte"] =  "\(parte.nParte)"
                    messageDictionary["prioridad"] =  "\(parte.prioridad)"
                    messageDictionary["fecha"] = mensaje.fecha
                    messageDictionary["mensajeId"] = mensaje.mensajeId
                    messageDictionary["totalPartes"] = "\(mensaje.totalPartes)"
                    messageDictionary["isImage"] = "1"
                    
                    if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                    }
                }
                
            }
        }
    }//fin función

    
    func connectedWithPeer2(_ peerID: MCPeerID) {
        //enviar mensajes
        print("Hola mundo omg")
        
        
        
        let allMessages = MensajeFacade().findAllMessages()
        for peer in appDelegate.mpcManager.session.connectedPeers {
            for mensaje in allMessages{
                var messageDictionary: [String: String] = ["origen": mensaje.origen]
                messageDictionary["destino"] = mensaje.destino//["destino": ]
                messageDictionary["mensaje"] =  mensaje.mensaje
                messageDictionary["fecha"] = mensaje.fecha
                messageDictionary["mensajeId"] = mensaje.mensajeId
                
                
                messageDictionary["hs"] = "1"
                if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                }
            }
        }
    }//fin función
    
    func handleMPCReceivedDataWithNotification(_ notification: Notification) {
        
        //print("recibiendo datos")
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as! Dictionary<String, String>
        // Check if there's an entry with the "message" key.
        
        if let handShake = dataDictionary["hs"] {
            self.hs["\(fromPeer)"] = true
            print("recibí HandShake de \(fromPeer)")
        }
        
        
        
        
        //cabezera
        var cabecera = ""
        if let dato = dataDictionary["cabecera"] {
            cabecera = dato
        }
        
        if cabecera == "check" {
            print("recibiendo check")
            for peer in appDelegate.mpcManager.session.connectedPeers {
                
                var mId: String = ""
                var nP: String = ""
                var peerId: String = ""
                if let dato = dataDictionary["mensajeId"] {
                    mId = dato
                }
                if let dato = dataDictionary["numeroParte"] {
                    nP = dato
                }
                if let dato = dataDictionary["peerId"] {
                    peerId = dato
                }
                
                let existe = MensajeFacade().exists(mId: mId, nP: Int(nP)!)
                
                var messageDictionary: [String: String] = ["cabecera": "check2"]
                
                
                if !existe {
                    messageDictionary["numeroParte"] =  "\(nP)"
                    messageDictionary["mensajeId"] = "\(mId)"
                    
                    if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                    }
                }
                
            }
        
        }else if cabecera == "check2" {
            
            print("recibiendo check2")
            var mId: String = ""
            var nP: String = ""
            var peerId: String = ""
            if let dato = dataDictionary["mensajeId"] {
                mId = dato
            }
            if let dato = dataDictionary["numeroParte"] {
                nP = dato
            }
            if let dato = dataDictionary["peerId"] {
                peerId = dato
            }

            
            
            let mensajesFiltrados = MensajeFacade().findMessageByIdAndNp(mId: mId, nP: Int(nP)!)
            
            for mensaje in mensajesFiltrados{
                for parte in mensaje.partes{
                    
                    let encodedData = parte.data.base64EncodedString(options: .lineLength64Characters)
                    
                    
                    var bolString = "0"
                    if mensaje.isImage{
                        bolString = "1"
                    }
                    
                    var messageDictionary: [String: String] = ["cabecera": "info"]
                    messageDictionary["origen"] = mensaje.origen
                    messageDictionary["destino"] = mensaje.destino//["destino": ]
                    messageDictionary["mensaje"] =     encodedData
                    messageDictionary["numeroParte"] =  "\(parte.nParte)"
                    messageDictionary["prioridad"] =  "\(parte.prioridad)"
                    messageDictionary["fecha"] = mensaje.fecha
                    messageDictionary["mensajeId"] = mensaje.mensajeId
                    messageDictionary["totalPartes"] = "\(mensaje.totalPartes)"
                    messageDictionary["isImage"] = "1"
                    
                    
                    for peer in appDelegate.mpcManager.session.connectedPeers {
                        if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                            print("enviando parte \(parte.nParte)")
                        }
                    }
                    
                }
                
            }
            
            
            
        }else if cabecera == "info" {
            print("recibiendo info")
            var origen: String = ""
            var destino: String = ""
            var mensaje: String = ""
            var fecha: String = ""
            var mensajeId: String = ""
            var nParte: Int = 0
            var prioridad: Int = 0
            var isImage = false
            var partesTotales = 0
            if let dato = dataDictionary["origen"] {
                origen = dato
            }
            if let dato = dataDictionary["destino"] {
                destino = dato
            }
            if let dato = dataDictionary["mensaje"] {
                mensaje = dato
            }
            if let dato = dataDictionary["numeroParte"] {
                nParte = Int(dato)!
            }
            if let dato = dataDictionary["prioridad"] {
                prioridad = Int(dato)!
            }
            if let dato = dataDictionary["fecha"] {
                fecha = dato
            }
            if let dato = dataDictionary["mensajeId"] {
                mensajeId = dato
            }
            if let dato = dataDictionary["isImage"] {
                print("mensaje imagen")
                if dato == "1"{
                    isImage = true
                }
            }
            if let dato = dataDictionary["totalPartes"] {
                partesTotales = Int(dato)!
            }
            
            
            print("recibí parte \(nParte)")
            
            
            let dataDecoded : Data = Data(base64Encoded: mensaje, options: .ignoreUnknownCharacters)!
            
            let parte = Parte(d: dataDecoded, nParte: nParte, p: prioridad, f: "")
            
            
            let objMensaje = Mensaje(o: origen, d: destino, f: fecha, mId: mensajeId, isImage: isImage, partes: [parte], pTotales: partesTotales)
            MensajeFacade().insert2(m: objMensaje)
            
            
            
            //enviar cambio de prioridad
            
            
            var messageDictionary: [String: String] = ["cabecera": "post"]
            messageDictionary["numeroParte"] =  "\(nParte)"
            messageDictionary["mensajeId"] = "\(mensajeId)"
            
            for peer in appDelegate.mpcManager.session.connectedPeers {
                if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peer as MCPeerID){
                }
            }
            
            
        }else if cabecera == "post"{
        
            
            var mensajeId: String = ""
            var nParte: Int = 0
            if let dato = dataDictionary["numeroParte"] {
                nParte = Int(dato)!
            }
            if let dato = dataDictionary["mensajeId"] {
                mensajeId = dato
            }
            MensajeFacade().updatePriority(mId: mensajeId, nP: nParte)
            
        }
        
        
        
    }


}


