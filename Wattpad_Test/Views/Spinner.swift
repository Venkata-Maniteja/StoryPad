//
//  Spinner.swift
//  Wattpad_Test
//
//  Created by Venkata Nandamuri on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class Spinner: UIView {

    @IBOutlet weak var background : UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addRotation()
        
    }
    
    /**
     This method adds the rotation animation for the spinner
     
     */
    private func addRotation(){
        //add rotation
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 0.7
        rotation.repeatCount = HUGE
        background.layer.removeAllAnimations()
        background.layer.add(rotation, forKey: "Spin")
    }
    
}
