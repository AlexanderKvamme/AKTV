import Foundation
import UIKit
import IGDB_SWIFT_API


fileprivate let diffableCellReuseID = "product-cell"

final class UIKitFavouriteScreen<T: Entity>: UIViewController, UICollectionViewDelegate where T: Hashable {
    
    // MARK: - Properties
    
    enum Section: Int, CaseIterable {
        case favourites
        case all
    }
    
    typealias items = [T]
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    private let header = UILabel.make(.header, color: UIColor(dark))
    private let subHeader = UILabel.make(.subtitle, color: UIColor(dark))
    private var items = [T]()
    
    // MARK: - Initializers

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        setup()
        addSubviewsAndConstraints()
        
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: diffableCellReuseID)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getFavourites()
    }
    
    private func addEntity(_ entity: Entity) {
        if let item = entity as? T {
            if !self.items.contains(where: {$0 == item}) {
                self.items.append(item)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, T>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(self.items, toSection: .favourites)
        
        dataSource.apply(snapshot)
    }
    
    private func getFavourites() {
        // TODO: Make this an extension on Show/Proto_game/Movie?
        if T.self == Show.self {
            let favs = UserProfileManager().favouriteShows()
            favs.forEach { showId in
                APIDAO().show(withId: showId) { show in
                    self.addEntity(show)
                }
            }
        } else if T.self == Movie.self {
            let favs = UserProfileManager().favouriteMovies()
            favs.forEach { movieId in
                APIDAO().movie(withId: UInt64(movieId)) { movie in
                    self.addEntity(movie)
                }
            }
        } else if T.self == Proto_Game.self {
            let favs = GameStore.getFavourites()
            favs.forEach { gameId in
                APIDAO().game(withId: UInt64(gameId)) { game in
                    self.addEntity(game)
                }
            }
        }
    }
    
    // MARK: - Methods
        
    private func setup() {
        header.text = "Your favourites"
        header.textColor = UIColor(dark)
        subHeader.text = "Pick one to see more"
        subHeader.textColor = UIColor(dark)
        subHeader.sizeToFit()
        view.backgroundColor = UIColor(light)
        collectionView.backgroundColor = UIColor(light)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func makeCollectionView() -> UICollectionView {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(collectionView)
        view.addSubview(header)
        view.addSubview(subHeader)
        
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(32)
        }
        
        subHeader.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(8)
            make.left.right.equalTo(header)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subHeader.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, T> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: makeCellRegistration().cellProvider
        )
    }
    
    func productListDidLoad(_ list: items) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, T>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .favourites)
        
        dataSource.apply(snapshot)
    }
    
    typealias CellRegistration = UICollectionView.CellRegistration<FavouriteCell, T>
    
    func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, product in
            cell.update(product)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  let cell = collectionView.cellForItem(at: indexPath) as? FavouriteCell,
            let entity = cell.entity {
            let detailedScreen = DetailedEntityScreen(entity: entity)
            detailedScreen.modalPresentationStyle = .fullScreen
            present(detailedScreen, animated: true)
        }
    }
}

private extension UIKitFavouriteScreen {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, _ in
            
            switch Section(rawValue: sectionIndex) {
            case .favourites:
                return self?.makeListLayoutSection()
            case .all:
                return self?.makeGridLayoutSection()
            case nil:
                return nil
            }
        }
    }
}

private extension UIKitFavouriteScreen {
    func makeListLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(FavouriteCell.size.height)
            ),
            subitems: [item]
        )
        
        let sectionLayout = NSCollectionLayoutSection(group: group)
        sectionLayout.interGroupSpacing = 8
        return sectionLayout
    }
}

extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return { collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(
                using: self,
                for: indexPath,
                item: product
            )
        }
    }
}

private extension UIKitFavouriteScreen {
    func makeGridLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitem: item,
            count: 2
        )
        
        return NSCollectionLayoutSection(group: group)
    }
}
