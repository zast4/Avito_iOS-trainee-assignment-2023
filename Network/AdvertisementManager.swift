//
//  AdvertisementManager.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

protocol AdvertisementManagerDelegate {
    func loadAdvertisements(
        _ advertisementManager: AdvertisementManager,
        advertisements: Advertisements
    )
    func loadAdvertisementDetailed(
        _ advertisementManager: AdvertisementManager,
        advertisementDetailed: AdvertisementDetailed
    )
    func didFailWithError(error: Error)
}

struct AdvertisementManager {
    let mainWindowURL = "https://www.avito.st/s/interns-ios/main-page.json"
    let detailedWindowURL = "https://www.avito.st/s/interns-ios/details/"

    var delegate: AdvertisementManagerDelegate?

    var advertisementDetailed: AdvertisementDetailed?

    func fetchAdvertisementDetailed(id: String) {
        let urlString = "\(detailedWindowURL)\(id).json"
        request(with: urlString, requestType: .detailedWindow)
    }

    func fetchAdvertisements() {
        let urlString = mainWindowURL
        request(with: urlString, requestType: .mainWindow)
    }

    func parseDetailedWindowJSON(_ networkAdvertisementDetailed: Data) -> AdvertisementDetailed? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let networkAdDetailed = try decoder.decode(
                NetworkAdvertisementDetailed.self,
                from: networkAdvertisementDetailed
            )

            let advertisementDetailed = NetworkConverter
                .networkAdDetailedToAdDetailed(networkAdDetailed)
            return advertisementDetailed
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    func parseMainWindowJSON(_ networkAdvertisements: Data) -> Advertisements? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let networkAdvertisements = try decoder.decode(
                NetworkAdvertisements.self,
                from: networkAdvertisements
            )
            
            let advertisements = NetworkConverter.networkAdsToAds(networkAdvertisements)
            return advertisements
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    private enum RequestType {
        case mainWindow
        case detailedWindow
    }

    private func request(with urlString: String, requestType: RequestType) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data { // Parse JSON here
                    switch requestType {
                    case .detailedWindow:
                        if let advertisementDetailed = self.parseDetailedWindowJSON(safeData) {
                            print("Detailed Window \(urlString)")
                            self.delegate?.loadAdvertisementDetailed(
                                self,
                                advertisementDetailed: advertisementDetailed
                            )
                        }
                    case .mainWindow:
                        if let advertisements = self.parseMainWindowJSON(safeData) {
                            print("Detailed Window \(urlString)")
                            self.delegate?.loadAdvertisements(self, advertisements: advertisements)
                        }
                        print("Main Window \(urlString)")
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
}
