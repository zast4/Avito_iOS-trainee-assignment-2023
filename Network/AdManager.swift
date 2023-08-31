//
//  AdvertisementManager.swift
//  Avito
//
//  Created by Даниил on 30.08.2023.
//

import Foundation

protocol AdManagerDelegate {
    func loadAds(
        _ advertisementManager: AdManager,
        ads: Ads
    )
    func loadAdDetailed(
        _ advertisementManager: AdManager,
        adDetailed: AdDetailed
    )
    func didFailWithError(error: Error)
}

struct AdManager {
    let mainWindowURL = "https://www.avito.st/s/interns-ios/main-page.json"
    let detailedWindowURL = "https://www.avito.st/s/interns-ios/details/"

    var delegate: AdManagerDelegate?

    var advertisementDetailed: AdDetailed?

    func fetchAdDetailed(id: String) {
        let urlString = "\(detailedWindowURL)\(id).json"
        request(with: urlString, type: RequestType.detailedWindow)
    }

    func fetchAds() {
        let urlString = mainWindowURL
        request(with: urlString, type: RequestType.mainWindow)
    }

    func parseDetailedWindowJSON(_ networkAdDetailed: Data) -> AdDetailed? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let networkAdDetailed = try decoder.decode(
                NetworkAdDetailed.self,
                from: networkAdDetailed
            )

            let adDetailed = NetworkConverter
                .networkAdDetailedToAdDetailed(networkAdDetailed)
            return adDetailed
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    func parseMainWindowJSON(_ networkAds: Data) -> Ads? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let networkAds = try decoder.decode(
                NetworkAds.self,
                from: networkAds
            )

            let ads = NetworkConverter.networkAdsToAds(networkAds)
            return ads
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    private enum RequestType {
        case mainWindow
        case detailedWindow
    }

    private func request(with urlString: String, type requestType: RequestType) {
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
                    case RequestType.detailedWindow:
                        if let advertisementDetailed = self.parseDetailedWindowJSON(safeData) {
                            self.delegate?.loadAdDetailed(
                                self,
                                adDetailed: advertisementDetailed
                            )
                        }
                    case RequestType.mainWindow:
                        if let advertisements = self.parseMainWindowJSON(safeData) {
                            self.delegate?.loadAds(self, ads: advertisements)
                        }
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
}
