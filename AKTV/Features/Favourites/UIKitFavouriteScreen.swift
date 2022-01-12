import Foundation
import UIKit


fileprivate let diffableCellReuseID = "product-cell"

final class UIKitFavouriteScreen<T: Entity>: UIViewController where T: Hashable {
    
    // MARK: - Properties
    
    enum Section: Int, CaseIterable {
        case favourites
    }
    
    typealias Product = T
    typealias ProductList = [Product]
    typealias Cell = TestCell
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Initializers

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        productListDidLoad(Show.mocks)
    }
    
    // MARK: - Methods
    
    private func setup() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .green
        view.backgroundColor = .orange
        
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        _ = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // Create cell registration that defines how data should be shown in a cell
        _ = UICollectionView.CellRegistration<UICollectionViewListCell, MediaPickable> { (cell, indexPath, item) in
            
            // Define how data should be shown using content configuration
            let content = cell.defaultContentConfiguration()
//            content.image = item.image
//            content.text = item.name
            
            // Assign content configuration to cell
            cell.contentConfiguration = content
        }
    }
    
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
    
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Product> // string should be the data type
    
    // let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellReuseID, for: indexPath) as! TestCell
    func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, product in
            print("bam making cell for ", indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "bam"
            cell.contentConfiguration = config
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    func makeGridLayoutSection() -> NSCollectionLayoutSection {
        // Each item will take up half of the width of the group
        // that contains it, as well as the entire available height:
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        ))
        
        // Each group will then take up the entire available
        // width, and set its height to half of that width, to
        // make each item square-shaped:
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
    
    func makeListLayoutSection() -> NSCollectionLayoutSection {
        // Here, each item completely fills its parent group:
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        
        // Each group then contains just a single item, and fills
        // the entire available width, while defining a fixed
        // height of 50 points:
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
            ),
            subitems: [item]
        )
        
        return NSCollectionLayoutSection(group: group)
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {
            [weak self] sectionIndex, environment in
            
            switch Section(rawValue: sectionIndex) {
//            case .featured, .onSale:
//                return self?.makeGridLayoutSection()
            case .favourites:
                // Creating our table view-like list layout using
                // a given appearence. Here we simply use 'plain':
                return .list(
                    using: UICollectionLayoutListConfiguration(
                        appearance: .plain
                    ),
                    layoutEnvironment: environment
                )
            case nil:
                return nil
            }
        }
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout.list(
            using: UICollectionLayoutListConfiguration(
                appearance: .insetGrouped
            )
        )
        
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
    }
}


extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return { collectionView, indexPath, product in
            collectionView.dequeueConfiguredReusableCell(
                using: self,
                for: indexPath,
                item: product
            )
        }
    }
}
