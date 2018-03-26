//
//  BandejaTableView.swift
//  MPCRevisited
//
//  Created by cedest on 8/10/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//
//


//clase principal, donde ocurre toda la logica de conexión
//además es la pantalla visual principal, donde se listan los mensajes
//que han sido recibidos exitosamente
import Foundation
import UIKit
import MultipeerConnectivity
import AVFoundation


class BandejaTableView: UIViewController, MPCManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    //configuracion de la tabla, solo son configuraciones visuales
    var section = ["Recibidos", "Completados"]
    var lista = [Mensaje]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    var stringLog = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtLog: UITextView!
    var flagAudio = false
    let systemSoundID: SystemSoundID = 1016 //sonido de pajaro
    
    
    //automatizacion de pruebas
    var favoritePeer: MCPeerID?
    var flagReceptor = false
    var flagEmisor = false
    var contadorReset: Double = 0
    var contador: Int = 0
    
    
    var flagReset = true
    //variables tiempo
    
    var lastId = ""
    var currentId = ""
    var lastPart: Int = 0
    var currentPart: Int = 0
    var currentTotalParts: Int = 0
    var currentTotalSize: Int = 0
    var currentPacketSize: Int = 0
    
    
    
    var dicTotalSize =  [String :Int]()
    var dicPacketSize =  [String :Int]()
    
    var tiempo: Double = 0
    var timer : Timer?
    
    var primerValor: Double = 0
    var segundoValor: Double = 0
    
    var dbTime1: Double = 0
    var dbTime2: Double = 0
    var dbTimeTotal: Double = 0
    
    var tiempoEncuentro: Double = 0
    var tiempoHandShake: Double = 0
    var tiempoConexion: Double = 0
    var tiempoCabecera : Double = 0
    var tiempoInicioMensaje : Double = 0
    var tiempoFinMensaje : Double = 0
    var tiempoDesconexion : Double = 0
    
    
    var handShakeTime1: Double = 0
    var handShakeTime2: Double = 0
    
    
    //configuración de timers para la realización de pruebas de campo
    //
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate para la tabla de iOS. Solo son funciones visuales
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Varios().crearBaseDeDatos()
        
        //Deja la búsqueda de peers activa en la vista
        appDelegate.mpcManager.delegate = self
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleMPCReceivedDataWithNotification(_:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Varios().crearBaseDeDatos()
        //consigue todos los mensajes que estén completos en la base de datos
        //y que le dispositivo de uso actual sea efectivamente el destinatario.
        self.lista = MensajeFacade().findAllForList()
        self.txtLog.text = ""
        stringLog = ""
        
        
        if UserDefaults.standard.integer(forKey: "size") == 0{
            UserDefaults.standard.set(0, forKey: "size")
            UserDefaults.standard.synchronize()
        }
        self.flagAudio = UserDefaults.standard.bool(forKey: "audio")
        actualizarTabla()
    }
    
    //funcion para actualizar visualmente la tabla
    func actualizarTabla(){
        self.tableView.reloadData()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    
    //configuración de la tabla
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//self.section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lista.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CeldaMensaje
        selectedID = cell.id
    }
    
    
    
    //encontró peer
    func foundPeer() {
        self.flagReset = true
        //actualiza el log, un cuadro de texto que se presenta en la vista para saber
        //que está sucediendo
        self.updateLog(s: "Encontré dispositivo")
        
        //actualiza un timer
        self.tiempoEncuentro = CFAbsoluteTimeGetCurrent()
        
        //recorre en todos los peers encontrados
        for peer in appDelegate.mpcManager.foundPeers {
            //guarda el primer peer como favorito
            self.favoritePeer = peer
            //se conecta con el peer
            if !appDelegate.mpcManager.session.connectedPeers.contains(peer){
                appDelegate.mpcManager.browser.invitePeer(peer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 3)
            }else{
                self.connectedWithPeer(peer)
            }
        }
    }
    
    //si pierde el peer
    func lostPeer() {
        if appDelegate.mpcManager.session.connectedPeers.count == 0{
            self.appDelegate.mpcManager.session.disconnect()
        }
        //consigue el tiempo de ejecución en este momento, con el fin de
        //realizar las pruebas de campo
        self.tiempoDesconexion = CFAbsoluteTimeGetCurrent()
        self.contadorReset = 0
        //actualiza un log visual
        self.updateLog(s: "Perdí conexión")
        print("LO PERDEMOS")
        
        
        if self.dicTotalSize[self.currentId] != nil && self.dicPacketSize[self.currentId] != nil {
             TiempoFacade().insert2(p1: self.currentPart, pTotales: self.currentTotalParts, size: self.dicTotalSize[self.currentId]!, partSize: self.dicPacketSize[self.currentId]!, t1: self.tiempoEncuentro, t2: self.tiempoHandShake, t3: self.tiempoConexion, t4: self.tiempoCabecera, t5: self.tiempoInicioMensaje, t6: self.tiempoFinMensaje, t7: self.tiempoDesconexion, t8: self.dbTimeTotal)
        }
        
        
    }
    
    
    
    func invitationWasReceived(_ fromPeer: String) {
        
        //crear sesión sin preguntar
        self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
        self.updateLog(s: "Recibí Handshake")
        //consigue el tiempo de ejecución en este momento, con el fin de
        //realizar las pruebas de campo
        self.tiempoHandShake = CFAbsoluteTimeGetCurrent()
        //guarda en una tabla de logs, el tiempo en el cual ocurre el handshake
        TiempoFacade().insertHandShake(t1: self.tiempoEncuentro, t2: self.tiempoHandShake, partSize:  UserDefaults.standard.integer(forKey: "size"))
        
    }
    
    
    //funcion al conectars con el peer por primera vez
    func connectedWithPeer(_ peerID: MCPeerID) {
        self.updateLog(s: "Conectado con dispositivo")
        //consigue el tiempo de ejecución en este momento, con el fin de
        //realizar las pruebas de campo
        self.tiempoConexion = CFAbsoluteTimeGetCurrent()
        //consigue todos los mensaje que tiene el dispositivo para enviar
        let allMessages = MensajeFacade().findAllMessages2()
        self.updateLog(s: "Encontré \(allMessages.count) mensajes para enviar")
        
        //itera en los mensajes
        for mensaje in allMessages{
            //si el mensaje tiene imagen o no
            var bolString = "0"
            if mensaje.isImage{
                bolString = "1"
            }
            
            //diccionario del mensaje que se enviará
            //cabecera tiene un string para la fase que se está comunicando, la primera es check
            var messageDictionary: [String: String] = ["cabecera": "check"]
            //envia el id del mensaje
            messageDictionary["mensajeId"] = mensaje.mensajeId
            //envia el tamaño de los chuncks del mensaje
            messageDictionary["packetSize"] = "\(mensaje.partSize)"
            //envia el tamaño total del mensaje
            messageDictionary["totalSize"] = "\(mensaje.totalSize)"
            //envia el mensaje por la conexión
            if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: peerID){
                self.updateLog(s: "Envié cabecera de mensaje")
            }
        }//fin de iteracion por mensajes
        
    }//fin función
    
    
    //recepción de mensajes
    
    func handleMPCReceivedDataWithNotification(_ notification: Notification) {
        
        //print("recibiendo datos")
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? NSData
        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        // Convert the data (NSData) into a Dictionary object.
        var dataDictionary: [String: String] = [:]
        
        
        do {
            dataDictionary = try NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as! Dictionary<String, String>
        
        }catch { return}
        // Check if there's an entry with the "message" key.
        
        //consigue la cabecera
        var cabecera = ""
        if let dato = dataDictionary["cabecera"] {
            cabecera = dato
        }
        
        //si la data recibida es el check (cabecera de los mensajes)
        if cabecera == "check" {
            print("recibiendo check")
            self.updateLog(s: "Recibí cabecera")
            //consigue el tiempo de ejecución para logs
            self.tiempoCabecera = CFAbsoluteTimeGetCurrent()
            var mId: String = ""
            var pSize: Int = 0
            var tSize: Int = 0
            var peerId: String = ""
            
            //consigue los datos del mensaje cabecera
            if let dato = dataDictionary["mensajeId"] {
                mId = dato
            }
            if let dato = dataDictionary["packetSize"] {
                pSize = Int(dato)!
            }
            if let dato = dataDictionary["totalSize"] {
                tSize = Int(dato)!
            }
            
            //guarda en diccionarios internos el tamaño de los Chunks y total del mensaje
            self.dicPacketSize[mId] = pSize
            self.dicTotalSize[mId] = tSize
            
            //consulta si ya tengo el mensaje completo en la base de datos local
            let existe = MensajeFacade().existsInBandeja(mId: mId)
            var ids = ""
            var messageDictionary: [String: String] = ["cabecera": "check2"]
            //si no tengo el mensaje completo en la base de datos
            if !existe {
                //consigo las partes que tengo actualmente del mensaje
                ids = MensajeFacade().partesNumero(mId: mId)
                messageDictionary["partes"] =  "\(ids)"
                messageDictionary["mensajeId"] = "\(mId)"
                
                if ids == ""{
                    print("no tengo ninguna parte")
                }
                
                
                //envio el mensaje por comunicación inalambrica, de las partes que me faltan por
                //cada mensaje
                if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: fromPeer){
                    self.updateLog(s: "Envié partes que me faltan")
                }
            }
        }else if cabecera == "check2" {
            //recibo la cantidad de partes que faltan
            print("recibiendo check2")
            var mId: String = ""
            var nP: String = ""
            var peerId: String = ""
            var partes = ""
            if let dato = dataDictionary["mensajeId"] {
                mId = dato
            }
            if let dato = dataDictionary["partes"] {
                partes = dato
            }
            if let dato = dataDictionary["peerId"] {
                peerId = dato
            }
            
            
            //consigo las partes que le faltan al otro peer, por mensaje
            let mensajesFiltrados = MensajeFacade().findMessageByIdAndNp(mId: mId, ids: partes)
            for mensaje in mensajesFiltrados{
                for parte in mensaje.partes{
                    let encodedData = parte.data.base64EncodedString(options: .lineLength64Characters)
                    //revisa si el mensaje es una imagen o texto
                    var bolString = "0"
                    if mensaje.isImage{
                        bolString = "1"
                    }
                    //configura el header del mensaje
                    var messageDictionary: [String: String] = ["cabecera": "info"]
                    //configura todos los datos de un mensaje, para el diccionario
                    //que será enviado por medio inalambrico
                    messageDictionary["origen"] = mensaje.origen
                    messageDictionary["destino"] = mensaje.destino//["destino": ]
                    messageDictionary["mensaje"] =     encodedData
                    messageDictionary["numeroParte"] =  "\(parte.nParte)"
                    messageDictionary["prioridad"] =  "\(parte.prioridad)"
                    messageDictionary["fecha"] = mensaje.fecha
                    messageDictionary["mensajeId"] = mensaje.mensajeId
                    messageDictionary["totalPartes"] = "\(mensaje.totalPartes)"
                    messageDictionary["isImage"] = "1"
                    messageDictionary["hash"] = parte.hash
                    
                    
                    //envia el mensaje por medio inalambrico
                    if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: fromPeer){
                        self.updateLog(s: "enviando parte \(parte.nParte) del mensaje \(mensaje.mensajeId) Total partes: \(mensaje.totalPartes)")
                    }
                }
            }
            
            
        //consigue el header del mensaje
        }else if cabecera == "info" {
            //si está reicibiendo información de mensajes
            //recupera todos los datos recibidos
            self.contadorReset = 0
            print("recibiendo info")
            self.flagReceptor = true
            var origen: String = ""
            var destino: String = ""
            var mensaje: String = ""
            var fecha: String = ""
            var mensajeId: String = ""
            var nParte: Int = 0
            var prioridad: Int = 0
            var isImage = false
            var partesTotales = 0
            var hash = ""
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
            if let dato = dataDictionary["hash"] {
                hash = dato
            }
            //revisa que ID de mensaje estoy recibiendo
            self.lastId = currentId
            self.currentId = mensajeId
            //si recibo IDs de mensajes distinto al anterior,
            //el mensaje anterior se recibió completo, por lo que
            //guarda el tiempo en una DB de logs
            if lastId != currentId {
                self.flagReset = true
                self.tiempoInicioMensaje = CFAbsoluteTimeGetCurrent()
                self.tiempoFinMensaje = 0
                self.dbTime1 = 0
                self.dbTime2 = 0
                self.dbTimeTotal = 0
            }
            
            
            
            let aux = MensajeFacade().cantidadPartes(mId: mensajeId)
            self.updateLog(s: "recibí parte \(nParte) del mensaje \(mensajeId)  \(aux[0])/\(aux[1])")
            
            self.currentPart = aux[0]
            self.currentTotalParts = aux[1]
            //suena un sonido, si así está configurado
            if self.flagAudio {
                // to play sound
                AudioServicesPlaySystemSound (systemSoundID)
            }
            
            
            let dataDecoded : Data = Data(base64Encoded: mensaje, options: .ignoreUnknownCharacters)!
            //crea un objeto Parte para mejor manejo de la data recibida
            let parte = Parte(d: dataDecoded, nParte: nParte, p: prioridad, f: "", h: hash)
            //paso la data de la parte por md5
            let miHash = Varios().md5(s: "\(dataDecoded)")
            //compruebo que el md5 realizado localmente sea igual al del mensaje recibido
            if miHash == hash {
                print("Mismo Hash!")
                let objMensaje = Mensaje(o: origen, d: destino, f: fecha, mId: mensajeId, isImage: isImage, partes: [parte], pTotales: partesTotales)
                //consigo tiempo de ejecución para DB logs
                self.dbTime1 = CFAbsoluteTimeGetCurrent()
                MensajeFacade().insert2(m: objMensaje)
                self.dbTime2 = CFAbsoluteTimeGetCurrent()
                
                self.dbTimeTotal += self.dbTime2 - self.dbTime1
                
                //compruebo si tengo todas las partes del mensaje que estoy recibiendo
                let listo = MensajeFacade().tengoTodasLasPartes(mId: mensajeId)
                if listo {
                    self.tiempoFinMensaje = CFAbsoluteTimeGetCurrent()
                    var sizes = MensajeFacade().comprobarMisMensajesById(mId: mensajeId)
                    self.updateLog(s: "Mensaje completo! Insertado a la tabla")
                    self.lista = MensajeFacade().findAllForList()
                    if sizes.count > 0 {
                        var time = self.segundoValor - self.primerValor
                        
                        //ingreso los tiempos obtenidos a lo largo de la ejecución a la tabla de logs
                        TiempoFacade().insert2(p1: self.currentPart, pTotales: self.currentTotalParts, size: self.dicTotalSize[mensajeId]!, partSize: self.dicPacketSize[mensajeId]!, t1: self.tiempoEncuentro, t2: self.tiempoHandShake, t3: self.tiempoConexion, t4: self.tiempoCabecera, t5: self.tiempoInicioMensaje, t6: self.tiempoFinMensaje, t7: self.tiempoDesconexion, t8: self.dbTimeTotal)
                        
                        self.dicTotalSize[mensajeId] = nil
                        self.dicPacketSize[mensajeId] = nil
                        
                    }else{
                        print("algo salió mal")
                    }
                    
                    //swift 3
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                }
                //enviar cambio de prioridad
                //configuro header
                var messageDictionary: [String: String] = ["cabecera": "post"]
                //cuerpo del mensaje
                messageDictionary["numeroParte"] =  "\(nParte)"
                messageDictionary["mensajeId"] = "\(mensajeId)"
                
                if appDelegate.mpcManager.sendData(dictionaryWithData: messageDictionary, toPeer: fromPeer){
                    
                }
            }else{
                self.updateLog(s: "Hash distintos!")
            }
        //si estoy recibiendo lo último de la conexión
        //(Actualización de prioridad para las partes)
        }else if cabecera == "post"{
            var mensajeId: String = ""
            var nParte: Int = 0
            if let dato = dataDictionary["numeroParte"] {
                nParte = Int(dato)!
            }
            if let dato = dataDictionary["mensajeId"] {
                mensajeId = dato
            }
            //actualizo las prioridadades de las partes que fueron recibidas
            //exitosamente
            MensajeFacade().updatePriority(mId: mensajeId, nP: nParte)
        }
    }
    
    
    func updateLog(s: String){
        DispatchQueue.main.async {
            self.stringLog += "\n \(s)"
            self.txtLog.text = self.stringLog
        }
    }
    
    override func viewDidLayoutSubviews() {
        txtLog.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
}


