import UIKit
import Kingfisher


final class FavouriteCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    static let size = CGRect(x: 0, y: 0, width: screenWidth, height: 64)
    
    private var imageView = UIImageView()
    private var rootView = UIView()
    private var label = UILabel()
    var entity: Entity?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: Self.size)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setup() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = .clear
        selectedBackgroundView = UIView.clear()
        
        label.font = UIFont.gilroy(.bold, 16)
        label.textColor = UIColor(dark)
        rootView.backgroundColor = .white
        rootView.layer.cornerRadius = 16
    }
    
    func update(_ product: Entity) {
        self.entity = product
        label.text = product.name
        imageView.kf.setImage(with: product.getMainGraphicsURL())
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

    }
    
    func addSubviewsAndConstraints() {
        contentView.addSubview(rootView)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        rootView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        label.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(16)
        }
    }
}

extension UIView {
    static func clear() -> UIView {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
}
