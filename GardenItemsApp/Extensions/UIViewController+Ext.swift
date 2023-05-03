//
//  UIViewController+Ext.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit

extension UIViewController {
    func presentCustomAlertOnMainThred(allertTitle: String, message: String, butonTitle: String){
        DispatchQueue.main.async {
            let allertVC = AlertVC(allertTitle: allertTitle, message: message, buttonTitle: butonTitle)
            allertVC.modalPresentationStyle = .overFullScreen
            allertVC.modalTransitionStyle = .crossDissolve
            self.present(allertVC, animated: true)
        }
    }
}
