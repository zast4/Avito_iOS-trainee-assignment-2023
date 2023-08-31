//
//  ImageDownloader.swift
//  Avito
//
//  Created by Даниил on 31.08.2023.
//

import UIKit

protocol Cancellable {
    func cancel()
}

class ImageService {
    func image(for url: URL, completion: @escaping (UIImage?) -> Void) -> Cancellable {
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            var image: UIImage?

            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }

            if let data = data {
                image = UIImage(data: data)
            }
        }

        dataTask.resume()

        return dataTask
    }
}

// MARK: - URLSessionTask + Cancellable

extension URLSessionTask: Cancellable {}
