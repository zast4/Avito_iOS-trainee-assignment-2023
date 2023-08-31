//
//  Product.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

struct Advertisement {
    var id: String
    var title: String
    var price: String
    var location: String
    var imageUrl: URL
    var createdDate: Date
}

struct Advertisements {
    var advertisements: [Advertisement]
}
