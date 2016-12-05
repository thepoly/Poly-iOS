//
//  StoryCell.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/7/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit
import QuartzCore

class StoryPhotoCell: StoryCell {
	
	var photoView = UIImageView()
	var gradient = CAGradientLayer()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier!)

		// Accessibility identifier for UI automation
		self.accessibilityIdentifier = "story-photo-cell"
		
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
		// Photo height
		self.photoView.heightAnchor.constraint(equalToConstant: 280).isActive = true
		
		// Vertical layout with photo
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-0-[photo]-0-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView, "title": self.titleLabel, "kicker": self.kickerLabel])
		)
		
		// Remove labels from cell contentView and add them to photoView
		self.titleLabel.removeFromSuperview()
		self.kickerLabel.removeFromSuperview()
		self.authorLabel.removeFromSuperview()
		self.photoView.addSubview(self.kickerLabel)
		self.photoView.addSubview(self.titleLabel)
		self.photoView.addSubview(self.authorLabel)
		
		// Spacing on sides of title
		self.photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[title]-20-|",
			options: [],
			metrics: nil,
			views: ["title": self.titleLabel])
		)
		// Spacing on sides of kicker
		self.photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[kicker]-20-|",
			options: [],
			metrics: nil,
			views: ["kicker": self.kickerLabel])
		)
		// Spacing on sides of author
		self.photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[author]-20-|",
			options: [],
			metrics: nil,
			views: ["author": self.authorLabel])
		)
		
		// Vertical layout
		self.photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[kicker]->=10-[title]-10-[author]-14-|",  // priority of 750 allows StoryPhotoCell to override it
			options: [],
			metrics: nil,
			views: ["title": self.titleLabel, "kicker": self.kickerLabel, "author": self.authorLabel])
		)
		
		// Photo shadow
		gradient.colors = [UIColor.black.withAlphaComponent(0.5).cgColor,
		                   UIColor.clear.cgColor,
		                   UIColor.clear.cgColor,
		                   UIColor.black.withAlphaComponent(0.8).cgColor,
						   UIColor.black.withAlphaComponent(0.9).cgColor]
		gradient.locations = [0.0, 0.2, 0.5, 0.8, 1.0]
		self.photoView.layer.insertSublayer(gradient, at: 0)
		
		// Title shadow
		self.titleLabel.textColor = UIColor.white
		self.titleLabel.layer.shadowColor = UIColor.black.cgColor
		self.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.titleLabel.layer.shadowRadius = 3
		self.titleLabel.layer.shadowOpacity = 1
		
		// Kicker shadow
		self.kickerLabel.textColor = UIColor(red: 0.98, green: 0.286, blue: 0.192, alpha: 1.0)
		self.kickerLabel.layer.shadowColor = UIColor.black.cgColor
		self.kickerLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.kickerLabel.layer.shadowRadius = 5
		self.kickerLabel.layer.shadowOpacity = 1
		
		// Author shadow
		self.authorLabel.textColor = UIColor.white
		self.authorLabel.layer.shadowColor = UIColor.black.cgColor
		self.authorLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.authorLabel.layer.shadowRadius = 3
		self.authorLabel.layer.shadowOpacity = 1
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Set the correct size for the gradient in photoView.
		// We use contentView's bounds instead of photoView's because
		// of some weirdness with Auto Layout not propagating to CALayers.
		// This works for now because the bounds of contentView == photoView.
		self.gradient.frame = self.contentView.bounds;
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
