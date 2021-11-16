import UIKit

final class TestViewController: UIViewController {

    // MARK: - Properties

    private var card = ImageCard()

    // MARK: - Initializers

    init(color: UIColor = .green) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(card)
        card.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(40)
        }

        let url = URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co3gbk.png")
//        card.imageView.kf.setImage(with: url)
    }
}
