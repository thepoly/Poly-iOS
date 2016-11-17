//
//  FeaturedStoryCell.swift
//  Poly
//
//  Created by Sidney Kochman on 11/13/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class FeaturedStoryCell: UICollectionViewCell {
	
	let categoryLabel = UILabel()
	let titleLabel = UILabel()
	var photoView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		// Photo
		self.photoView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.photoView)
		self.photoView.contentMode = UIViewContentMode.scaleAspectFill
		self.photoView.clipsToBounds = true
		// Zero spacing on sides of photo
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[photo]-0-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView])
		)
		
		// Vertical layout with photo
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-0-[photo]-0-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView])
		)
		
		// Category
		// Container
		let categoryContainer = UIView()
		categoryContainer.translatesAutoresizingMaskIntoConstraints = false
		categoryContainer.backgroundColor = UIColor(red: 0.8617, green: 0.1186, blue: 0.0198, alpha: 0.8)
		self.contentView.addSubview(categoryContainer)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-0-[category]",
			options: [],
			metrics: nil,
			views: ["category": categoryContainer])
		)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[category]-0-|",
			options: [],
			metrics: nil,
			views: ["category": categoryContainer])
		)
		
		// Label
		categoryContainer.addSubview(self.categoryLabel)
		self.categoryLabel.translatesAutoresizingMaskIntoConstraints = false
		self.categoryLabel.numberOfLines = 0
		self.categoryLabel.lineBreakMode = .byWordWrapping
		self.categoryLabel.textColor = .white
		self.categoryLabel.font = UIFont(name: "AvenirNext-Bold", size: 16)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-2-[category]-1-|",
			options: [],
			metrics: nil,
			views: ["category": categoryLabel])
		)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-[category]-|",
			options: [],
			metrics: nil,
			views: ["category": categoryLabel])
		)
		
		// Title
		// Container
		let titleContainer = UIView()
		titleContainer.translatesAutoresizingMaskIntoConstraints = false
		titleContainer.backgroundColor = UIColor(red: 0.8617, green: 0.1186, blue: 0.0198, alpha: 0.8)
		self.contentView.addSubview(titleContainer)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[title]-0-|",
			options: [],
			metrics: nil,
			views: ["title": titleContainer])
		)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[title]-0-|",
			options: [],
			metrics: nil,
			views: ["title": titleContainer])
		)
		
		// Label
		titleContainer.addSubview(self.titleLabel)
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.titleLabel.numberOfLines = 0
		self.titleLabel.lineBreakMode = .byWordWrapping
		self.titleLabel.textColor = .white
		self.titleLabel.textAlignment = .center
		self.titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-1-[title]-3-|",
			options: [],
			metrics: nil,
			views: ["title": titleLabel])
		)
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-[title]-|",
			options: [],
			metrics: nil,
			views: ["title": titleLabel])
		)
		
		// Cell height
		self.contentView.heightAnchor.constraint(equalToConstant: 170).isActive = true
		self.contentView.widthAnchor.constraint(equalToConstant: 200).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
