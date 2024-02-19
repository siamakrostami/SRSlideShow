//
//  SRSlideShowCVC.swift
//  SRSlideShow
//
//  Created by Siamak on 2/18/24.
//

import NVActivityIndicatorView
import SDWebImage
import UIKit

class SRSlideShowCVC: UICollectionViewCell {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        SRConstraintBuilder.shared.addSubviewTo(containerView: contentView, view: imageView)
            .addSubviewTo(containerView: imageView, view: indicator)
            .createConstraint(forItem: imageView, withConstraintType: .centerX, toItem: contentView, withAttribute: .centerX)
            .createConstraint(forItem: imageView, withConstraintType: .centerY, toItem: contentView, withAttribute: .centerY)
            .createConstraint(forItem: imageView, withConstraintType: .width, toItem: contentView, withAttribute: .width)
            .createConstraint(forItem: imageView, withConstraintType: .height, toItem: contentView, withAttribute: .height)
            .createConstraint(forItem: indicator, withConstraintType: .centerX, toItem: imageView, withAttribute: .centerX)
            .createConstraint(forItem: indicator, withConstraintType: .centerY, toItem: imageView, withAttribute: .centerY)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    static let identifier = "MaaniSlideShowCVC"

    func configureCell(url: String?) {
        guard let url = url else {
            imageView.image = nil
            indicator.startAnimating()
            return
        }
        indicator.startAnimating()
        imageView.sd_setImage(with: URL(string: url)) { [weak self] image, error, _, _ in
            if error == nil {
                self?.indicator.stopAnimating()
                self?.imageView.image = image
            }
        }
    }

    func configureCell(image: UIImage?) {
        guard let image else {return}
        imageView.image = image
    }

    // MARK: Private

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private lazy var indicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .init(x: 0, y: 0, width: 60, height: 40), type: .ballBeat, color: .systemBlue)
        return view
    }()
}
