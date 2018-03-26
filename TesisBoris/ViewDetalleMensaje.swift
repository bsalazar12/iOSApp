//
//  V.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


//Ventana que muestra el mensaje de un destinatario
import Foundation


var selectedID = ""
class ViewDetalleMensaje: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtMensaje: UITextView!
    @IBOutlet weak var boxImagen: UIImageView!
    
    
    var selectedMensaje = Mensaje()
    
    //función que carga al aparecer la vista en pantalla
    override func viewWillAppear(_ animated: Bool) {
        
        //consigue los datos desde la base de datos
        //para mostrar en la pantalla
        self.selectedMensaje = MensajeFacade().findById(id: selectedID)
        self.txtMensaje.text = selectedMensaje.mensaje
        self.txtNumero.text = selectedMensaje.origen
        
        //pasa la data conseguida de la base de datos a un objeto imagen
        //para ser visualizado en la vista
        let imagenRecuperada = UIImage(data: self.selectedMensaje.MensajeBytes)
        print("bytes")
        print(self.selectedMensaje.MensajeBytes.count)
        
        //se asegura que el mensaje de verdad sea una imagen
        //para las primeras pruebas, todos los mensajes fueron imagenes
        if self.selectedMensaje.isImage {
            print("detalle imagen")
            let imagenRecuperada = UIImage(data: self.selectedMensaje.MensajeBytes)
            self.boxImagen.image = imagenRecuperada
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //carga el texto del mensaje, si tuviera
        self.txtMensaje.delegate = self
        self.txtMensaje.layer.borderWidth = CGFloat(Float(1.0))
        self.txtMensaje.layer.borderColor = Varios().colorWithHexString(hex: "3CA0A0").cgColor
    }
}
