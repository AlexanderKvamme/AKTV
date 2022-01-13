import UIKit


final class TestCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    static let size = CGRect(x: 0, y: 0, width: screenWidth, height: 64)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: Self.size)
        backgroundColor = .red
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    // MARK: - Methods

}
