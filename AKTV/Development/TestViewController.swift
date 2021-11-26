import UIKit
import SwiftUI

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
        
        APIDAO().movie(withId: 1538) { collateral in
            DispatchQueue.main.async {
                let entityScreen = SUDetailedEntity(entity: collateral)
                let vc = UIHostingController(rootView: entityScreen)
                self.present(vc, animated: true)
            }
        }
    }
}
