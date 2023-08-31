//
//  AdDetailedViewController.swift
//  Avito
//
//  Created by Даниил on 31.08.2023.
//

import UIKit

class AdDetailedViewController: UIViewController {
    private var adManager = AdManager()

    var adID: String? // ID for element indication

    private var adDetailed: AdDetailed? // Detailed advertisement to load on the screen

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
                case let .failure(error): // Handling Network error
                    print(error)
                    self?.showAlert(
                        title: "Error",
                        message: "Отсутствует подключение к сети или происходит проблема с установлением соединения с сервером"
                    ) { index in
                        if index == 0 {
                            DispatchQueue.main.async {
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            }
                        }
                    }
                    print("Interner error in detailed")
                case .success:
                    break
                }
            }
        }
    }

    // MARK: - Image services

    private var imageRequest: Cancellable?

    private lazy var imageService = ImageService()

    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adEmailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let adPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
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

    // MARK: - Seting layout

    private func setupUI(_ adDetailed: AdDetailed) {
        setupSubviews()
        setAttributes(adDetailed)
        setupConstraints()
    }

    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            adImageView,
            adPlaceholder,
            adPriceLabel,
            adTitleLabel,
            adAddressLabel,
            descriptionLabel,
            adDescriptionLabel,
            contactsLabel,
            adEmailLabel,
            adPhoneNumberLabel,
            adCreatedDateLabel
        ].forEach { view in
            contentView.addSubview(view)
        }
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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            adImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            adImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            adImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            adPlaceholder.widthAnchor.constraint(equalToConstant: view.frame.width),
            adPlaceholder.heightAnchor.constraint(equalToConstant: view.frame.width),
            adPlaceholder.topAnchor.constraint(equalTo: contentView.topAnchor),
            adPlaceholder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            adPriceLabel.topAnchor.constraint(equalTo: adImageView.bottomAnchor, constant: 12),
            adPriceLabel.leadingAnchor.constraint(equalTo: adImageView.leadingAnchor, constant: 15),

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
            adCreatedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: - Loading advertisements

extension AdDetailedViewController: AdManagerDelegate {
    // For first controller
    func loadAds(_ advertisementManager: AdManager, ads: Ads) {}

    func loadAdDetailed(_ advertisementManager: AdManager, adDetailed: AdDetailed) {
        DispatchQueue.main.async {
            self.setupUI(adDetailed)
        }
    }
}
