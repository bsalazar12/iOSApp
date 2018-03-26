//
//  ViewConfiguracion.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//





//Ventana de configuracion, para guardar algunas opciones tecnicas
//como el ID con el cual se está identificando el dispositivo
//Además de opciones de base de datos, como borrar todos los datos de las imagenes
//o de los logs

//No hay nada realmente importante para la logica del programa en este archivo
import Foundation
import MessageUI
class ViewConfiguracion: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtSize: UITextField!
    @IBOutlet weak var switchAudio: UISwitch!
    
    //boton que al apretar actualiza los datos guardados.
    @IBAction func Guardar(_ sender: Any) {
        UserDefaults.standard.set(txtNumero.text!, forKey: "numero")
        UserDefaults.standard.set(Int(txtSize.text!)!, forKey: "size")
        UserDefaults.standard.set(self.switchAudio.isOn, forKey: "audio")
        UserDefaults.standard.synchronize()
        self.navigationController!.popViewController(animated: true)
    }
    
    //funcion que carga las opciones guardadas anteriormente
    override func viewWillAppear(_ animated: Bool) {
        self.txtNumero.text = Varios().miNumero()
        self.txtSize.text = "\(Varios().miSize())"
        self.switchAudio.isOn = UserDefaults.standard.bool(forKey: "audio")
        
    }
    
    
    //borrar DB
    @IBAction func BorrarDb(_ sender: Any) {
        let alert = UIAlertController(title: "Atención", message: "Se han borrado todos los mensajes del dispositivo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        MensajeFacade().deleteAll()
    }
    
    //Borrar logs de la prueba
    @IBAction func borrarLogs(_ sender: Any) {
        let alert = UIAlertController(title: "Atención", message: "Se han borrado los logs", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        TiempoFacade().borrarTabla()
    }
    
    @IBAction func borrarEntregas(_ sender: Any) {
        
        let alert = UIAlertController(title: "Atención", message: "Se han borrado los logs", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        TiempoFacade().borrarTablaEntrega()
        
    }
    
    @IBAction func borrarHS(_ sender: Any) {
        
        let alert = UIAlertController(title: "Atención", message: "Se han borrado los logs", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        TiempoFacade().borrarTablaHandShake()    }
    
    @IBAction func enviarMailEntrega(_ sender: Any) {
        
        let fileName = "entregas.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = TiempoFacade().getAllEntregas()
        
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            present(vc, animated: true, completion: nil)
            
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    @IBAction func enviarMail(_ sender: Any) {
        let fileName = "Tasks.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = TiempoFacade().getAll()
        
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            present(vc, animated: true, completion: nil)
            
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    
    @IBAction func enviarMailHS(_ sender: Any) {
        let fileName = "handShake.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = TiempoFacade().getAllHandShake()
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            present(vc, animated: true, completion: nil)
            
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
    }
    
    
    
    
    
    
    func mail(){
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Have you heard a swift?")
            mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
            
            if let filePath = Bundle.main.path(forResource: "info", ofType: "csv") {
                print("File path loaded.")
                
                if let fileData = NSData(contentsOfFile: filePath) {
                    print("File data loaded.")
                    mailComposer.addAttachmentData(fileData as Data, mimeType: "csv", fileName: "info")
                }
            }
            self.present(mailComposer, animated: true, completion: nil)
        }
    }

}
