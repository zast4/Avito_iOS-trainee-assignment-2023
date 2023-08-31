//
//  ViewController.swift
//  Avito
//
//  Created by Даниил on 28.08.2023.
//

import UIKit

class ViewController: UIViewController {
    var advertisementManager = AdvertisementManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        advertisementManager.delegate = self
        advertisementManager.fetchAdvertisements()
        // advertisementManager.fetchAdvertisementDetailed(id: "1")
        view.backgroundColor = .blue
    }
}

// MARK: - AdvertisementManagerDelegate

extension ViewController: AdvertisementManagerDelegate {
    func loadAdvertisements(_ advertisementManager: AdvertisementManager, advertisements: Advertisements) {
        print("loadAdvertisements")
        print(advertisements.advertisements.count)
        print(advertisements.advertisements[0].id)
        print(advertisements.advertisements[0].title)
        print(advertisements.advertisements[0].price)
        print(advertisements.advertisements[0].location)
        print(advertisements.advertisements[0].imageUrl)
        print(advertisements.advertisements[0].createdDate)
    }
    
    func loadAdvertisementDetailed(_ advertisementManager: AdvertisementManager, advertisementDetailed: AdvertisementDetailed) {
        print("loadAdvertisementDetailed")
        print(advertisementDetailed.id)
        print(advertisementDetailed.title)
        print(advertisementDetailed.price)
        print(advertisementDetailed.location)
        print(advertisementDetailed.imageUrl)
        print(advertisementDetailed.createdDate)
        print(advertisementDetailed.description)
        print(advertisementDetailed.email)
        print(advertisementDetailed.phoneNumber)
        print(advertisementDetailed.address)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
