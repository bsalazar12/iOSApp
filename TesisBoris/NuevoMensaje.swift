//
//  NuevoMensaje.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

//View donde se crea un nuevo mensaje, además donde ocurre
//la conversión de la imagen a DATA, y la DATA es cortada en trozos para ser
//enviada a la base de datos por parte.


import Foundation

var dataGlobal = Data()
class NuevoMensaje: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var txtDestinatario: UITextField!
    @IBOutlet weak var txtMensaje: UITextView!
    @IBOutlet weak var btnAdjuntarImagen: UIButton!
    @IBOutlet weak var boxImagen: UIImageView!
    var imageData = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtMensaje.delegate = self
        self.txtMensaje.layer.borderWidth = CGFloat(Float(1.0))
        self.txtMensaje.layer.borderColor = Varios().colorWithHexString(hex: "3CA0A0").cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    //Funcion de cuadro de texto. Si se utiliza solo imagenes, esto no es necesario
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Escriba aquí"{
            textView.text = ""
        }
        let algo = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.plain, target: self, action: #selector(completar))
        self.navigationItem.setRightBarButton(algo, animated: true)
        
    }
    
    //Funcion para el manejo de cuadro de texto
    func dismissKeyboard() {
        view.endEditing(true)
        let algo = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = algo
    }
    //Funcion para el manejo de cuadro de texto
    func completar(){
        self.dismissKeyboard()
    }
    
    
    
    //Funcion que guarda
    func save(_ sender: Any) {
        if UserDefaults.standard.integer(forKey: "n") == nil{
            UserDefaults.standard.set(0, forKey: "n")
            UserDefaults.standard.synchronize()
        }
        //guarda internamente un contador del mensaje actual
        //Esto para que al unir al contador, con la identificación única del
        //dispositivo, sea una clave única
        let n = UserDefaults.standard.integer(forKey: "n")
        UserDefaults.standard.set(n + 1, forKey: "n")
        UserDefaults.standard.synchronize()
        
        let miNumero = UserDefaults.standard.string(forKey: "numero")
        
        var mensaje = Mensaje()
        
        //crea un objeto mensaje con una imagen
        if self.imageData != nil {
            print("imagen no es nula")
            mensaje = Mensaje(o: miNumero!, d: self.txtDestinatario.text!, m: self.imageData, f: "", mId: "\(miNumero!)n\(n)", isImage: true)
        }else{//crea un objeto mensaje con texto
            mensaje = Mensaje(o: miNumero!, d: self.txtDestinatario.text!, m: self.txtMensaje.text!, f: "", mId: "\(miNumero!)n\(n)")
        }
        
        
        
        var trozosMensaje: [Data] = []
        if self.imageData != nil{
            //toma la imagen seleccionada desde la galeria de iOS
            //y la corta nuevamente
            trozosMensaje = Varios().createChunks(forData: self.imageData)
        }
        
        //crea un arreglo de objetos Parte
        var partes: [Parte] = []
        var totalSize = 0
        if self.imageData != nil {
            var index = 0
            //itera a travez de casa parte en que de trozó la imagen
            for parte in trozosMensaje{
                totalSize += parte.count
                //crea una parte de forma individual, con algunos bites del mensaje
                let parte = Parte(d: parte, nParte: index, p: 1, f: "")
                partes.append(parte)
                index += 1
            }
        }
        
        
        //consigue desde las configuraciones del programa, el tamaño de chunk que se está
        //utilizando actualmente
        mensaje.partSize = Varios().miSize()
        //guarda en el objeto mensaje el total del tamaño de la imagen
        mensaje.totalSize = totalSize
        //guarda las partes en el objeto mensaje
        mensaje.partes = partes
        //guarda la cantidad de partes en el objeto mensaje
        mensaje.totalPartes = partes.count
        //guarda el objeto mensaje en la base de datos
        MensajeFacade().insert2(m: mensaje)
        
        //vuelve atrás
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //Función para seleccionar una imagen de la galeria de iOS
    @IBAction func AbrirGaleria(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    //Función cuando una imagen es seleccionada de la glería de iOS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //hace aparecer un boton para guardar la imagen
        let algo = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = algo
        print(info)
        //obtengo la información de la imagen seleccionada como imagen manejable de iOS
        let a  = info["UIImagePickerControllerOriginalImage"] as! UIImage
        //Convierto la imagen en algo visible de forma universal, en este caso, una imagen
        //en JPG levemente comprimida
        let imageData =   UIImageJPEGRepresentation(a, 0.85) //UIImagePNGRepresentation(a)
        dataGlobal = imageData!
        self.imageData = imageData!
        //saca la vista de selección de imagen de iOS
        self.dismiss(animated: true, completion: nil);
    
        
        //Proceso de partición de la data de imagen
        //La función createChuncks hace todo el trabajo
        let partes = Varios().createChunks(forData: imageData!)
        
        
        //Se restaura la imagen a partir de las partes creadas
        //Esto a modo de prueba, a ver si la función anterior funcionó
        var dataFinal = Data()
        //Cada parte de adiciona a nivel de Bits en orden
        for p in partes {
            dataFinal.append(p)
        }
        //Cuando se junta todos los trozos de imagenes a nivel de bits, se restaura la imagen
        self.imageData = dataFinal
        
        //Se deja la imagen en formato visible para la vista en IOS
        let imagenRecuperada = UIImage(data: dataFinal)
        //se muestra la imagen recuperada de forma visual en la vista
        self.boxImagen.image = imagenRecuperada
        
    }
}
