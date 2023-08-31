//
//  ProductData.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

struct NetworkAd: Decodable {
    var id: String
    var title: String
    var price: String
    var location: String
    var imageUrl: String
    var createdDate: String
}

struct NetworkAds: Decodable {
    let advertisements: [NetworkAd]
}
