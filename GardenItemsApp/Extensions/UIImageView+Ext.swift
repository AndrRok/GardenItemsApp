//
//  UIImageView+Ext.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/30/23.
//

import UIKit

extension UIImageView {
    func setRounded() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
    }
}
