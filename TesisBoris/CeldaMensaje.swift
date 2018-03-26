//
//  CeldaMensaje.swift
//  MPCRevisited
//
//  Created by cedest on 12/1/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//


//clase para hacer celdas interactivas.
//solo es una clase para fines visuales, no influye en la lógica
import Foundation
class CeldaMensaje: MGSwipeTableCell {
    
    @IBOutlet weak var labelOrigen: UILabel!
    @IBOutlet weak var labelMensaje: UILabel!

    var id: String = ""
    var completed: Bool = false
    var pId: String = ""
    var oId: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
