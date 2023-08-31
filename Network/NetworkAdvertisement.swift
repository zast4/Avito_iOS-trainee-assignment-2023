//
//  ProductData.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

struct NetworkAdvertisement: Decodable {
    var id: String
    var title: String
    var price: String
    var location: String
    var imageUrl: String
    var createdDate: String
}

struct NetworkAdvertisements: Decodable {
    let advertisements: [NetworkAdvertisement]
}
