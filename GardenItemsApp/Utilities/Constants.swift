//
//  Constants.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit

enum Images {
    static let placeholder  = UIImage(named: "placeholderimage")
    static let mapPin  = UIImage(named: "MapPin") 
}

enum ErrorMessages: String, Error {
    case invalidRequest     = "This request created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
}

enum Values{
    static let  padding: CGFloat                    = 20
}
