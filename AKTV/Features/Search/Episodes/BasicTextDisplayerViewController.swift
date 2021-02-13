

import UIKit

final class BasicTextDisplayerViewController: UIViewController {
    
    // MARK: Properties

    let episodeHeader = UILabel()
    let episodeTextView = UITextView()
    
    // MARK: Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        view.backgroundColor = UIColor(dark)

        episodeHeader.font = UIFont.gilroy(.heavy, 48)
        episodeHeader.adjustsFontSizeToFitWidth = true
        episodeHeader.textColor = UIColor(light)
        episodeHeader.textAlignment = .center

        episodeTextView.font = UIFont.gilroy(.regular, 20)
        episodeTextView.textColor = UIColor(light)
        episodeTextView.isUserInteractionEnabled = false
        episodeTextView.backgroundColor = .clear
        episodeTextView.alpha = UIFont.defaultBodyAlpha
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(episodeHeader)
        view.addSubview(episodeTextView)

        episodeHeader.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }

        episodeTextView.snp.makeConstraints { (make) in
            make.top.equalTo(episodeHeader.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: Internal methods
    
    func update(with episode: Episode) {
        episodeTextView.text = episode.overview
        episodeHeader.text = episode.name
    }
}
