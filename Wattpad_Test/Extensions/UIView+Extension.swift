//
//  UIView+Extension.swift
//  Wattpad_Test
//
//  Created by Rupika Sompalli on 23/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
