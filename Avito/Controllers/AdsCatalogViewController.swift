//
//  ViewController.swift
//  Avito
//
//  Created by Даниил on 28.08.2023.
//

import UIKit

class AdsCatalogViewController: UIViewController {
    private var adManager = AdManager()

    private var ads: Ads? // Advertisements from Network layer

    override func viewDidLoad() {
        super.viewDidLoad()
        adManager.delegate = self

        self.fetchDataForAdCollectionView()

        adCollectionView.dataSource = self
        adCollectionView.delegate = self
    }

    // MARK: - UI Elements

    private lazy var extendedFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let width = view.bounds.width
        let padding: CGFloat = 8
        let minimumItemSpacing: CGFloat = 8
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        flowLayout.sectionInset = UIEdgeInsets(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + (itemWidth * 0.7))
        return flowLayout
    }()

    private lazy var adCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: extendedFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            AdCollectionViewCell.self,
            forCellWithReuseIdentifier: "AdCollecitonViewCell"
        )

        return collectionView
    }()

    // MARK: - Fetch data for adCollecitonView

    private func fetchDataForAdCollectionView() {
        adManager.fetchAds { [weak self] result in
            switch result {
            case let .failure(error): // Handling network error
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
            case .success:
                break
            }
        }
    }
}

// MARK: - Setup layout

extension AdsCatalogViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(adCollectionView)

        NSLayoutConstraint.activate([
            adCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            adCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            adCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        adCollectionView.dataSource = self
        adCollectionView.delegate = self
    }
}

// MARK: - Loading advertisement

extension AdsCatalogViewController: AdManagerDelegate {
    func loadAds(_ adManager: AdManager, ads: Ads) {
        self.ads = ads
        DispatchQueue.main.async {
            self.setupUI() // Can setup UI after getting advertisements array
        }
    }

    // Method for AdDetailedController
    func loadAdDetailed(_ adManager: AdManager, adDetailed: AdDetailed) {}
}

// MARK: - UICollectionViewDataSource

extension AdsCatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let ads = ads {
            return ads.advertisements.count
        } else {
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCollecitonViewCell", for: indexPath) as? AdCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        if let ads = ads {
            cell.setupSubviews(ads.advertisements[indexPath.row])
        } else {
            cell.setupSubviews(Ad(
                id: "1",
                title: "Смартфон Apple iPhone 12 ",
                price: "55000 ₽",
                location: "Москва",
                imageUrl: URL(string: "https://www.avito.st/s/interns-ios/images/1.png")!,
                createdDate: .now
            ))
        }
        return cell
    }
}

// MARK: - Setup CollectionView

extension AdsCatalogViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let advertisemainDetailedVC = AdDetailedViewController()
        advertisemainDetailedVC.adID = ads?.advertisements[indexPath.row].id
        navigationController?.pushViewController(advertisemainDetailedVC, animated: true)
    }
}

extension AdsCatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let flowlayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowlayout?.minimumInteritemSpacing ?? 0.0) +
            (flowlayout?.sectionInset.left ?? 0.0) + (flowlayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (adCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size + (size * 0.6))
    }
}
