//
//  AdDetailedViewController.swift
//  Avito
//
//  Created by Даниил on 31.08.2023.
//

import UIKit

class AdDetailedViewController: UIViewController {
    var adID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        adManager.delegate = self
        fetchAdDetailedData()
        
    }
    
    private func fetchAdDetailedData() {
        if let adID = adID {
            adManager.fetchAdDetailed(id: adID) { [weak self] result in
                switch result {
                case let .failure(error):
                    self?.showAlert(title: "Error",
                                   message: "Отсутствует подключение к сети или происходит проблема с установлением соединения с сервером")
                    { index in
                        if index == 0 {
                            DispatchQueue.main.async {
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            }
                        }
                    }
                    print("Interner error in detailed")
                case .success(_):
                    break
                }
            }
        }
    }

    private var adDetailed: AdDetailed?

    private var adManager = AdManager()
    
    private var imageRequest: Cancellable?
    
    private lazy var imageService = ImageService()

    private let adImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let adPlaceholder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let adPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adEmailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adCreatedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupUI(_ adDetailed: AdDetailed) {
        setupSubviews()
        setAttributes(adDetailed)
        setupConstraints()
    }

    private func setupSubviews() {
        view.addSubview(adImageView)
        view.addSubview(adPlaceholder)
        view.addSubview(adPriceLabel)
        view.addSubview(adTitleLabel)
        view.addSubview(adAddressLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(adDescriptionLabel)
        view.addSubview(contactsLabel)
        view.addSubview(adEmailLabel)
        view.addSubview(adPhoneNumberLabel)
        view.addSubview(adCreatedDateLabel)
    }

    private func setAttributes(_ adDetailed: AdDetailed) {
        imageRequest = imageService.image(for: adDetailed.imageUrl) { [weak self] image in
            self?.adImageView.image = image
            self?.adPlaceholder.isHidden = true
        }
        adPriceLabel.text = adDetailed.price
        adTitleLabel.text = adDetailed.title
        adAddressLabel.text = adDetailed
            .location + ", " + adDetailed.address
        adDescriptionLabel.text = adDetailed.description
        adEmailLabel.text = adDetailed.email
        adPhoneNumberLabel.text = adDetailed.phoneNumber
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "d MMMM, yyyy"
        let dateString = dateFormatter.string(from: adDetailed.createdDate)
        adCreatedDateLabel.text = dateString
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            adImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            adImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            adImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            adPlaceholder.widthAnchor.constraint(equalToConstant: view.frame.width),
            adPlaceholder.heightAnchor.constraint(equalToConstant: view.frame.width),
            adPlaceholder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            adPriceLabel.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: 12),
            adPriceLabel.leadingAnchor.constraint(equalTo: adImageView.leadingAnchor, constant: 12),
            
            adTitleLabel.leadingAnchor.constraint(equalTo: adPriceLabel.leadingAnchor),
            adTitleLabel.topAnchor.constraint(equalTo: adPriceLabel.bottomAnchor, constant: 6),
            
            adAddressLabel.leadingAnchor.constraint(equalTo: adTitleLabel.leadingAnchor),
            adAddressLabel.topAnchor.constraint(equalTo: adTitleLabel.bottomAnchor, constant: 6),
            
            descriptionLabel.topAnchor.constraint(equalTo: adAddressLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: adAddressLabel.leadingAnchor),
            
            adDescriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            adDescriptionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            adDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            
            contactsLabel.topAnchor.constraint(equalTo: adDescriptionLabel.bottomAnchor, constant: 16),
            contactsLabel.leadingAnchor.constraint(equalTo: adDescriptionLabel.leadingAnchor),
            
            adEmailLabel.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 12),
            adEmailLabel.leadingAnchor.constraint(equalTo: contactsLabel.leadingAnchor),
            
            adPhoneNumberLabel.topAnchor.constraint(equalTo: adEmailLabel.bottomAnchor, constant: 12),
            adPhoneNumberLabel.leadingAnchor.constraint(equalTo: adEmailLabel.leadingAnchor),
            
            adCreatedDateLabel.topAnchor.constraint(equalTo: adPhoneNumberLabel.bottomAnchor, constant: 16),
            adCreatedDateLabel.leadingAnchor.constraint(equalTo: adPhoneNumberLabel.leadingAnchor),
        ])
    }
}

extension AdDetailedViewController: AdManagerDelegate {
    func loadAds(_ advertisementManager: AdManager, ads: Ads) {}
    
    func loadAdDetailed(_ advertisementManager: AdManager, adDetailed: AdDetailed) {
        DispatchQueue.main.async {
            self.setupUI(adDetailed)
        }
    }
    
    func didFailWithError(error: Error) {
        print("didFailWithError")
    }
    
    
}
