import UIKit

final class ColoredViewController: UIViewController {

    // MARK: - Initializers

    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
