//
//  GardenItem.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import Foundation

struct GardenItem: Codable {
    let id: Int
    let image: String
    let name: String
    let description: String
    let categories: Logo
}

struct Logo: Codable{
    let icon: String
}

