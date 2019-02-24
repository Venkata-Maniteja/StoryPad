//
//  UIView+Extension.swift
//  Wattpad_Test
//
//  Created by Venkata Nandamuri on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /**
     This method loads the view from the nib
     
     */
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    /**
     This method adds blur view to the parent view it is added to
     
     */
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    /**
     This method removes all blur views that is added to the parent view
     
     */
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}

