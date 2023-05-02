//
//  String+Ext.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit
extension String{
    var encodeUrl : String
    {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String
    {
        return self.removingPercentEncoding!
    }
}
