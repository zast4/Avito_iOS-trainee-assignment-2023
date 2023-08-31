//
//  AdCollecitonViewCell.swift
//  Avito
//
//  Created by Даниил on 31.08.2023.
//

import UIKit

class AdCollectionViewCell: UICollectionViewCell {
    // MARK: - Elements
    
    private lazy var imageService = ImageService()
    
    private var imageRequest: Cancellable?
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view;
    }()
    
    private let placeholder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let favourites: UIImageView = {
//
//    }()
    
//    private let details: UIImageView = {
//
//    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Setting layout
    
    private func addSubviews() {
        addSubview(mainView)
        mainView.addSubview(imageView)
        mainView.addSubview(placeholder)
        mainView.addSubview(titleLabel)
        mainView.addSubview(priceLabel)
        mainView.addSubview(locationLabel)
        mainView.addSubview(createdDate)
    }
    
    public func setupSubviews(_ ad: Ad) {
        imageRequest = imageService.image(for: ad.imageUrl) { [weak self] image in
            self?.imageView.image = image
            self?.placeholder.isHidden = true
        }
        titleLabel.text = ad.title
        priceLabel.text = ad.price
        locationLabel.text = ad.location
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "d MMMM, yyyy"
        let dateString = dateFormatter.string(from: ad.createdDate)
        createdDate.text = dateString
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: mainView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            placeholder.topAnchor.constraint(equalTo: mainView.topAnchor),
            placeholder.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            placeholder.heightAnchor.constraint(equalTo: placeholder.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: placeholder.bottomAnchor, constant: 4),
            titleLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor, constant: -24),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            
            createdDate.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            createdDate.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
        ])
    }
    
    static var reuseIdentifier: String {
        return String(describing: AdCollectionViewCell.self)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = nil
            placeholder.isHidden = false
            titleLabel.text = nil
            priceLabel.text = nil
            locationLabel.text = nil
            createdDate.text = nil
            imageRequest?.cancel()
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
