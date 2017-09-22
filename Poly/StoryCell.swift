//
//  StoryPhotoCell.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/7/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class StoryCell: UICollectionViewCell {
	
	var containerView = UIView()
	var kickerLabel = UILabel()
	var titleLabel = UILabel()
	var authorLabel = UILabel()
	var titleContainer = UIVisualEffectView()
	var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
	let maskLayer = CAShapeLayer()
	
	func setWidth(_ width: CGFloat) {
		self.contentView.widthAnchor.constraint(equalToConstant: width).isActive = true
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.contentView.translatesAutoresizingMaskIntoConstraints = false
		
		// Background mask (rounded corners)
		self.containerView.translatesAutoresizingMaskIntoConstraints = false
		self.containerView.backgroundColor = UIColor.white
		self.containerView.layer.mask = self.maskLayer
		self.contentView.addSubview(self.containerView)
		
		// Fill contentView with containerView
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|[container]|",
			options: [],
			metrics: nil,
			views: ["container": self.containerView])
		)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|[container]|",
			options: [],
			metrics: nil,
			views: ["container": self.containerView])
		)
		
		// Shadow behind cell
		self.contentView.layer.shadowOffset = CGSize(width: 0, height: 10)
		self.contentView.layer.shadowColor = UIColor.black.cgColor
		self.contentView.layer.shadowRadius = 10
		self.contentView.layer.shadowOpacity = 0.12
		self.contentView.layer.masksToBounds = false
		
		// Accessibility identifier for UI automation
		self.accessibilityIdentifier = "story-cell"
		
		// Title
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.titleLabel.textAlignment = .left
		self.titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 24)
		self.titleLabel.numberOfLines = 0
		self.titleLabel.lineBreakMode = .byWordWrapping
		// Blurry background
		self.titleContainer = UIVisualEffectView(effect: self.blurEffect)
		self.titleContainer.translatesAutoresizingMaskIntoConstraints = false
		self.containerView.addSubview(self.titleContainer)
		self.titleContainer.contentView.addSubview(self.titleLabel)
		// Spacing on sides of title
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[titleContainer]-0-|",
			options: [],
			metrics: nil,
			views: ["titleContainer": self.titleContainer])
		)
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[title]-20-|",
			options: [],
			metrics: nil,
			views: ["title": self.titleLabel])
		)
		
		// Kicker
		self.kickerLabel.translatesAutoresizingMaskIntoConstraints = false
		titleContainer.contentView.addSubview(self.kickerLabel)
		self.kickerLabel.textAlignment = .left
		self.kickerLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
		self.kickerLabel.textColor = UIColor(red: 0.8617, green: 0.1186, blue: 0.0198, alpha: 1)
		self.kickerLabel.numberOfLines = 0
		self.kickerLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of kicker
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[kicker]-20-|",
			options: [],
			metrics: nil,
			views: ["kicker": self.kickerLabel])
		)
		
		// Author
		self.authorLabel.translatesAutoresizingMaskIntoConstraints = false
		self.containerView.addSubview(self.authorLabel)
		self.authorLabel.textAlignment = .left
		self.authorLabel.font = UIFont(name: "AvenirNext-Bold", size: 14)
		self.authorLabel.numberOfLines = 0
		self.authorLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of author
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[author]-20-|",
			options: [],
			metrics: nil,
			views: ["author": self.authorLabel])
		)
		
		// Vertical layout
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-0@750-[titleContainer]-0-|",  // priority of 750 allows StoryPhotoCell to override it
			options: [],
			metrics: nil,
			views: ["titleContainer": self.titleContainer, "kicker": self.kickerLabel, "author": self.authorLabel])
		)
		// Vertical layout inside blur
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[kicker]-10-[title]-15-|",
			options: [],
			metrics: nil,
			views: ["title": self.titleLabel, "kicker": self.kickerLabel, "author": self.authorLabel])
		)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//forces the system to do one layout pass
	var isHeightCalculated: Bool = false
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		//Exhibit A - We need to cache our calculation to prevent a crash.
		if !isHeightCalculated {
			setNeedsLayout()
			layoutIfNeeded()
			let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
			var newFrame = layoutAttributes.frame
			newFrame.size.width = CGFloat(ceilf(Float(size.width)))
			newFrame.size.height = CGFloat(ceilf(Float(size.height)))
			layoutAttributes.frame = newFrame
			isHeightCalculated = true
		}
		
		self.updateMask()
		return layoutAttributes
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.updateMask()
	}
	
	func updateMask() {
		let path = UIBezierPath(roundedRect: self.contentView.bounds,
		                        byRoundingCorners: [.topRight, .topLeft, .bottomRight, .bottomLeft],
		                        cornerRadii: CGSize(width: 12, height: 12))
		self.maskLayer.path = path.cgPath
	}
}
