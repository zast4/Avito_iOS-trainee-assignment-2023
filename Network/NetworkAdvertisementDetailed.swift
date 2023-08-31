//
//  AdvertisementDetailedData.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

struct NetworkAdvertisementDetailed: Decodable {
    var id: String
    var title: String
    var price: String
    var location: String
    var imageUrl: String
    var createdDate: String
    var description: String
    var email: String
    var phoneNumber: String
    var address: String
}
