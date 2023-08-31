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
    public func fetchAds(completion: @escaping (Result<NetworkAds, Error>) -> ()) {
        let urlString = mainWindowURL
        request(with: urlString, type: RequestType.mainWindow, completion: completion)
    }

    public func fetchAdDetailed(
        id: String,
        completion: @escaping (Result<NetworkAdDetailed, Error>) -> ()
    ) {
        let urlString = "\(detailedWindowURL)\(id).json"
        request(with: urlString, type: RequestType.detailedWindow, completion: completion)
    }

    let mainWindowURL = "https://www.avito.st/s/interns-ios/main-page.json"
    let detailedWindowURL = "https://www.avito.st/s/interns-ios/details/"

    var delegate: AdManagerDelegate?

    var advertisementDetailed: AdDetailed?

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

    private func request<T>(
        with urlString: String,
        type requestType: RequestType,
        completion: @escaping (Result<T, Error>) -> ()
    ) where T: Decodable {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3)
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: request) { data, response, error in

                if let error = error {
                    if (error as NSError).code == NSURLErrorTimedOut {
                        let timeoutError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
                        DispatchQueue.main.async {
                            completion(.failure(timeoutError))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    // self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("response не может быть приведен к типу ﻿HTTPURLResponse")
                    DispatchQueue.main.async {
                        completion(.failure(URLError(.badServerResponse)))
                    }
                    return
                }
                
                let statusCode = httpResponse.statusCode
                
                guard (200 ..< 300).contains(statusCode) else {
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    let userInfo = [NSLocalizedDescriptionKey: errorDescription]
                    let httpError = NSError(domain: "HTTP", code: statusCode, userInfo: userInfo)
                    print("HTTP-статус код ответа на запрос не находится в диапазоне успешных (200-299)")
                    DispatchQueue.main.async {
                        completion(.failure(httpError))
                    }
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
