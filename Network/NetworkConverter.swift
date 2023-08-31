//
//  NetworkConverter.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

struct NetworkConverter {
    static public func networkAdToAd(_ networkAd: NetworkAdvertisement) -> Advertisement {
        let ad = Advertisement(
            id: networkAd.id,
            title: networkAd.title,
            price: networkAd.price,
            location: networkAd.location,
            imageUrl: URL(string: networkAd.imageUrl)!,
            createdDate: createDateFromString(networkAd.createdDate)
        )
        return ad
    }
    
    static public func networkAdsToAds(_ networkAds: NetworkAdvertisements) -> Advertisements {
        return Advertisements(advertisements: networkAds.advertisements.map { networkAdToAd($0) })
    }

    static public func networkAdDetailedToAdDetailed(_ networkAdDetailed: NetworkAdvertisementDetailed)
        -> AdvertisementDetailed {
        let adDetailed = AdvertisementDetailed(
            id: networkAdDetailed.id,
            title: networkAdDetailed.title,
            price: networkAdDetailed.price,
            location: networkAdDetailed.location,
            imageUrl: URL(string: networkAdDetailed.imageUrl)!,
            createdDate: createDateFromString(networkAdDetailed.createdDate),
            description: networkAdDetailed.description,
            email: networkAdDetailed.email,
            phoneNumber: networkAdDetailed.phoneNumber,
            address: networkAdDetailed.address
        )
            return adDetailed
    }

    static private func createDateFromString(_ string: String) -> Date {
        let dateString = string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date(timeIntervalSince1970: TimeInterval(0))
        }
    }
}
