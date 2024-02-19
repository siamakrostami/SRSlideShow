//
//  ViewController.swift
//  SRSlideShow
//
//  Created by Siamak on 2/18/24.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        setupLocalSlideshow()
        setupRemoteSlideshow()
        // Do any additional setup after loading the view.
    }

    // MARK: Private

    private lazy var remoteSlideShow: SRSlideShow = {
        let slideshow = SRSlideShow(frame: .zero, type: .remote)
        return slideshow
    }()

    private lazy var localSlideShow: SRSlideShow = {
        let slideshow = SRSlideShow(frame: .zero, type: .local)
        return slideshow
    }()
}

extension ViewController {
    private func layoutView() {
        SRConstraintBuilder.shared
            .addSubviewsTo(containerView: view, views: [remoteSlideShow, localSlideShow])
            // Remote
            .createConstraint(forItem: remoteSlideShow, withConstraintType: .centerX, toItem: view, withAttribute: .centerX)
            .createConstraint(forItem: remoteSlideShow, withConstraintType: .top, toItem: view.safeAreaLayoutGuide, withAttribute: .top, constant: 16)
            .createConstraint(forItem: remoteSlideShow, withConstraintType: .width, toItem: view, withAttribute: .width, multiplier: 0.9)
            .createConstraint(forItem: remoteSlideShow, withConstraintType: .height, toItem: remoteSlideShow, withAttribute: .width, multiplier: 9 / 16)
            // Local
            .createConstraint(forItem: localSlideShow, withConstraintType: .centerX, toItem: remoteSlideShow, withAttribute: .centerX)
            .createConstraint(forItem: localSlideShow, withConstraintType: .top, toItem: remoteSlideShow, withAttribute: .bottom, constant: 16)
            .createConstraint(forItem: localSlideShow, withConstraintType: .width, toItem: remoteSlideShow, withAttribute: .width)
            .createConstraint(forItem: localSlideShow, withConstraintType: .height, toItem: remoteSlideShow, withAttribute: .height)
    }

    private func setupLocalSlideshow() {
        let imagesArray: [UIImage] = [.first, .second, .third, .fourth, .fifth]
        localSlideShow.banners = imagesArray
    }

    private func setupRemoteSlideshow() {
        let imagesArray: [String] = ["https://r4.wallpaperflare.com/wallpaper/264/666/478/3-316-16-9-aspect-ratio-s-sfw-wallpaper-7910883d41aafdcb36f7487fb0f1964d.jpg",
            "https://r4.wallpaperflare.com/wallpaper/115/292/869/3-316-16-9-aspect-ratio-s-sfw-wallpaper-192078fd31ba3d5bf60708bf10a116ad.jpg",
            "https://r4.wallpaperflare.com/wallpaper/237/293/295/3-316-16-9-aspect-ratio-s-sfw-wallpaper-b990b88d910a5dbb36a7c8ff20c1a6cd.jpg",
            "https://r4.wallpaperflare.com/wallpaper/1000/190/378/3-316-16-9-aspect-ratio-s-sfw-wallpaper-f900587d215a7d5b1617586fc03106fd.jpg",
            "https://r4.wallpaperflare.com/wallpaper/990/382/349/3-316-16-9-aspect-ratio-s-sfw-wallpaper-4930782d811a8d6b76a7e81f5061867d.jpg"]
        remoteSlideShow.banners = imagesArray
    }
}
