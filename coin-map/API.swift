//
//  API.swift
//  coin-map
//
//  Created by Marat Saytakov on 16.11.2019.
//  Copyright © 2019 saytakov. All rights reserved.
//

import Foundation

class Place: Codable {
    let id: String,
    name: String,
    latitude: Double,
    longitude: Double,
    categoryId: String,
    description: String,
    phone: String,
    website: String,
    openingHours: String,
    visible: Bool
//  , createdAt: Date
//  , updatedAt: Date
}
