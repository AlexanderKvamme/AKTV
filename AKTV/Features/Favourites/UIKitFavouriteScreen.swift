import Foundation
import UIKit


fileprivate let diffableCellReuseID = "product-cell"

final class UIKitFavouriteScreen<T: Entity>: UIViewController where T: Hashable {
    
    // MARK: - Properties
    
    enum Section: Int, CaseIterable {
        case favourites
        case all
    }
    
    typealias Product = T
    typealias ProductList = [Product]
    typealias Cell = TestCell
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()
    
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
        
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: diffableCellReuseID)
        collectionView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let test = Show.mocks as? [T] {
            print("casted: ", test.count)
            productListDidLoad(test)
        }
    }
    
    // MARK: - Methods
    
    func makeCollectionView() -> UICollectionView {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
    }
    
    private func setup() {}
    
    private func addSubviewsAndConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, T> {
        UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: makeCellRegistration().cellProvider
        )
    }
    
    func productListDidLoad(_ list: ProductList) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, T>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .favourites)
        
        dataSource.apply(snapshot)
    }
    
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Product>
    
    func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, product in
            var config = cell.defaultContentConfiguration()
            config.text = product.name
            cell.contentConfiguration = config
            cell.frame = TestCell.size
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
                heightDimension: .absolute(50)
            ),
            subitems: [item]
        )
        
        return NSCollectionLayoutSection(group: group)
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
