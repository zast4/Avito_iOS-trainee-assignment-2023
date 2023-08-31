//
//  UIViewControllerExtension.swift
//  Avito
//
//  Created by Даниил on 31.08.2023.
//

import UIKit

extension UIViewController {
    @discardableResult
    func showAlert(
        title: String?,
        message: String?,
        buttonTitles: [String]? = nil,
        highlightedButtonIndex: Int? = nil,
        completion: ((Int) -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.isEmpty {
            allButtons.append("OK")
        }

        for index in 0 ..< allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
                completion?(index)
            })
            alertController.addAction(action)
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
}
