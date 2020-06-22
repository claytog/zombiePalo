//
//  UIImageView+Extension.swift
//  ZombiePalo
//
//  Created by Clayton on 21/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}
