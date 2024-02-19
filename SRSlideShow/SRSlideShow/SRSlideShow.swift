//
//  SRSlideShow.swift
//  SRSlideShow
//
//  Created by Siamak on 2/18/24.
//

import Combine
import UIKit

// MARK: - SRSlideShow

class SRSlideShow: UIView {
    // MARK: Lifecycle

    init(frame: CGRect, type: SlideshowType) {
        self.type = type
        super.init(frame: frame)
        layoutView()
        bindBackground()
        bindCornerRadius()
        bindBanners()
        configureBannerCompositionalLayout()
        pageControl.currentPage = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("slideshow deinited")
        timer?.invalidate()
        timer = nil
    }

    // MARK: Internal

    @Published var collectionBackgroundColor: UIColor = .lightGray
    @Published var collectionCornerRadius: CGFloat = 12
    @Published var banners: [Any]?

    // MARK: Private

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SRSlideShowCVC.self, forCellWithReuseIdentifier: SRSlideShowCVC.identifier)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl(frame: .zero)
        control.addTarget(self, action: #selector(pageControlChanged), for: .touchUpInside)
        control.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        return control
    }()

    private var cancellabels = Set<AnyCancellable>()
    
    private var timer: Timer?
    private var counter: Int = 0
    
    private var type: SlideshowType

    private var currentSlideshowIndex: Int = 0 {
        didSet {
            if oldValue != currentSlideshowIndex {
                if currentSlideshowIndex < 0 {
                    currentSlideshowIndex = 0
                }
                counter = currentSlideshowIndex
                pageControl.currentPage = currentSlideshowIndex
            }
        }
    }
}

extension SRSlideShow {
    private func layoutView() {
        SRConstraintBuilder.shared.addSubviewsTo(containerView: self, views: [collectionView])
            .addSubviewTo(containerView: self, view: pageControl)
            .createConstraint(forItem: collectionView, withConstraintType: .centerX, toItem: self, withAttribute: .centerX)
            .createConstraint(forItem: collectionView, withConstraintType: .centerY, toItem: self, withAttribute: .centerY)
            .createConstraint(forItem: collectionView, withConstraintType: .width, toItem: self, withAttribute: .width)
            .createConstraint(forItem: collectionView, withConstraintType: .height, toItem: self, withAttribute: .height)
            .createConstraint(forItem: pageControl, withConstraintType: .centerX, toItem: self, withAttribute: .centerX)
            .createConstraint(forItem: pageControl, withConstraintType: .bottom, toItem: collectionView, withAttribute: .bottom, constant: -8)
            .createConstraint(forItem: pageControl, withConstraintType: .width, toItem: collectionView, withAttribute: .width, multiplier: 0.5)
    }
    
    private func bindBackground() {
        $collectionBackgroundColor.sink { [weak self] color in
            self?.collectionView.backgroundColor = color
        }.store(in: &cancellabels)
    }
    
    private func bindCornerRadius() {
        $collectionCornerRadius.sink { [weak self] radius in
            self?.collectionView.layer.cornerRadius = radius
        }.store(in: &cancellabels)
    }
    
    private func bindBanners() {
        $banners.sink { [weak self] banners in
            guard let self else {
                return
            }
            if banners != nil {
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.slide), userInfo: nil, repeats: true)
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.currentSlideshowIndex = 0
                self.collectionView.reloadData()
            }
            self.pageControl.numberOfPages = banners?.count ?? 0
            self.collectionView.reloadData()
        }.store(in: &cancellabels)
    }
    
    private func configureBannerCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            self?.bannerSection()
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func bannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, _ in
            guard let itemWidth = items.last?.bounds.width else {
                return
            }
            let page = round(offset.x / itemWidth)
            self?.currentSlideshowIndex = Int(page)
        }
        return section
    }
    
    @objc private func pageControlChanged() {
        collectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc private func slide() {
        let index = IndexPath(row: counter, section: 0)
        if counter < (banners?.count ?? 0) - 1 {
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension SRSlideShow: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SRSlideShowCVC.identifier, for: indexPath) as? SRSlideShowCVC else {
            return .init()
        }
        switch type {
        case .remote:
            cell.configureCell(url: banners?[indexPath.row] as? String)
        default:
            cell.configureCell(image: banners?[indexPath.row] as? UIImage)
        }
        
        return cell
    }
}
