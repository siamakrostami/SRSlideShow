//
//  SRConstraintHelper.swift
//  SRConstraintsHelper
//
//  Created by Siamak Rostami on 1/5/24.
//

import Foundation
import UIKit

// MARK: - SRConstraintBuilder

class SRConstraintBuilder {
    // MARK: Lifecycle

    private init() {}

    // MARK: Internal

    static let shared = SRConstraintBuilder()

    @discardableResult
    func addSubviewTo(containerView: UIView, view: UIView) -> Self {
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return self
    }
    
    @discardableResult
    func addSubviewsTo(containerView: UIView, views: [UIView]) -> Self {
        views.forEach {[weak self] view in
            guard let _ = self else {return}
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)
        }
        return self
    }
    
    @discardableResult
    func addArrangedSubviewTo(containerStackView: UIStackView, view: UIView) -> Self {
        view.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func addArrangedSubviewsTo(containerStackView: UIStackView, views: [UIView]) -> Self {
        views.forEach {[weak self] view in
            guard let _ = self else {return}
            view.translatesAutoresizingMaskIntoConstraints = false
            containerStackView.addArrangedSubview(view)
        }
        return self
    }

    @discardableResult
    func createConstraint(forItem: Any, withConstraintType: ConstraintType, relatedBy: NSLayoutConstraint.Relation? = .equal, toItem: Any?, withAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat? = 1, constant: CGFloat? = 0) -> Self {
        var constraint: NSLayoutConstraint?
        switch withConstraintType {
        case .top:
            constraint = NSLayoutConstraint(item: forItem, attribute: .top, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .bottom:
            constraint = NSLayoutConstraint(item: forItem, attribute: .bottom, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .leading:
            constraint = NSLayoutConstraint(item: forItem, attribute: .leading, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .trailing:
            constraint = NSLayoutConstraint(item: forItem, attribute: .trailing, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .centerX:
            constraint = NSLayoutConstraint(item: forItem, attribute: .centerX, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .centerY:
            constraint = NSLayoutConstraint(item: forItem, attribute: .centerY, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .height:
            constraint = NSLayoutConstraint(item: forItem, attribute: .height, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .width:
            constraint = NSLayoutConstraint(item: forItem, attribute: .width, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .left:
            constraint = NSLayoutConstraint(item: forItem, attribute: .left, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        case .right:
            constraint = NSLayoutConstraint(item: forItem, attribute: .right, relatedBy: relatedBy ?? .equal, toItem: toItem, attribute: withAttribute, multiplier: multiplier ?? 1, constant: constant ?? 0)
            constraint?.identifier = withConstraintType.rawValue
            constraint?.isActive = true
        }
        constraintsArray?.append(constraint ?? .init())
        return self
    }

    @discardableResult
    func updateConstraint(of view: UIView, withConstraintType: ConstraintType , constant: CGFloat) -> Self {
        guard let constraintIndex = view.constraints.firstIndex(where: { $0.identifier == withConstraintType.rawValue }) else {
            return self
        }
        view.constraints[constraintIndex].constant = constant
        return self
    }

    // MARK: Private

    private var constraintsArray: [NSLayoutConstraint]?
}
