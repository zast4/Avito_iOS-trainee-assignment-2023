//
//  ViewController.swift
//  Avito
//
//  Created by Даниил on 28.08.2023.
//

import UIKit

class AdsCatalogViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        adManager.delegate = self

        fetchDataForAdCollectionView()
        
        adCollectionView.dataSource = self
        adCollectionView.delegate = self

        
        // advertisementManager.fetchAdvertisementDetailed(id: "1")
        // view.backgroundColor = .blue
    }

    private var adManager = AdManager()

    private var ads: Ads?

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
}

// MARK: - Setup Layout

extension AdsCatalogViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(adCollectionView)

        NSLayoutConstraint.activate([
            adCollectionView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adCollectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 8
            ),
            adCollectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -8
            ),
            adCollectionView.bottomAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        adCollectionView.dataSource = self
        adCollectionView.delegate = self
    }

    private func fetchDataForAdCollectionView() {
        adManager.fetchAds() { [weak self] result in
            switch result {
            case let .failure(error):
                print("Interner error")
            case let .success(_):
                print("No error")
            }
        }
    }
}

// MARK: - AdvertisementManagerDelegate

extension AdsCatalogViewController: AdManagerDelegate {

    func loadAds(_ advertisementManager: AdManager, ads: Ads) {
        self.ads = ads
//        print("loadAdvertisements")
//        print(ads.advertisements.count)
//        print(ads.advertisements[0].id)
//        print(ads.advertisements[0].title)
//        print(ads.advertisements[0].price)
//        print(ads.advertisements[0].location)
//        print(ads.advertisements[0].imageUrl)
//        print(ads.advertisements[0].createdDate)
        DispatchQueue.main.async {
            self.setupUI()
        }
    }

    func loadAdDetailed(
        _ advertisementManager: AdManager,
        adDetailed: AdDetailed
    ) {
//        print("loadAdvertisementDetailed")
//        print(adDetailed.id)
//        print(adDetailed.title)
//        print(adDetailed.price)
//        print(adDetailed.location)
//        print(adDetailed.imageUrl)
//        print(adDetailed.createdDate)
//        print(adDetailed.description)
//        print(adDetailed.email)
//        print(adDetailed.phoneNumber)
//        print(adDetailed.address)
    }

    func didFailWithError(error: Error) {
        print("didFailWithError AdsCatalogViewController")
    }
}

// MARK: - UICollectionViewDataSource

extension AdsCatalogViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    )
        -> Int {
        if let ads = ads {
            return ads.advertisements.count
        } else {
            return 10
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    )
        -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AdCollecitonViewCell",
            for: indexPath
        ) as? AdCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        if let ads = ads {
            cell.setupSubviews(ads.advertisements[indexPath.row])
        } else {
            cell.setupSubviews(Ad(
                id: "1",
                title: "Смартфон Apple iPhone 12 оригинал 100% клянусь мамой папой братом собакой",
                price: "55000 ₽",
                location: "Москва",
                imageUrl: URL(string: "https://www.avito.st/s/interns-ios/images/1.png")!,
                createdDate: .now
            ))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AdsCatalogViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let advertisemainDetailedVC = AdDetailedViewController()
        advertisemainDetailedVC.adID = ads?.advertisements[indexPath.row].id
        navigationController?.pushViewController(advertisemainDetailedVC, animated: true)

    }
}

// MARK: - Setup CollectionView

extension AdsCatalogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (adCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size + (size * 0.6))
    }
}

//final class CommentFlowLayout: UICollectionViewFlowLayout {
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]
//        layoutAttributesObjects?.forEach { layoutAttributes in
//            if layoutAttributes.representedElementCategory == .cell {
//                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
//                    layoutAttributes.frame = newFrame
//                }
//            }
//        }
//        return layoutAttributesObjects
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collectionView = collectionView else { fatalError() }
//        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
//            return nil
//        }
//
//        layoutAttributes.frame.origin.x = sectionInset.left
//        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
//        return layoutAttributes
//    }
//}

// extension AdsCatalogViewController {
//    private func configureCollectionView() {
//        adCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: extendedFlowLayout)
//        guard let collectionView = collectionView else { return }
//        view.addSubview(collectionView)
//        collectionView.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.reuseIdentifier)
//    }
// }
