//
//  StoryPhotoCell.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/7/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class StoryPhotoCell: StoryCell {
	
	var photoView = UIImageView()
	var gradient = CAGradientLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		// Accessibility identifier for UI automation
		self.accessibilityIdentifier = "story-photo-cell"
		
		// Vertical layout
//		self.containerView.addConstraints(NSLayoutConstraint.constraints(
//			withVisualFormat: "V:|-200-[titleContainer]-0-|",
//			options: [],
//			metrics: nil,
//			views: ["titleContainer": self.titleContainer])
//		)
		
		// Photo
		self.photoView.translatesAutoresizingMaskIntoConstraints = false
		self.containerView.insertSubview(self.photoView, at: 0)
		self.photoView.contentMode = UIViewContentMode.scaleAspectFill
		// Zero spacing on sides of photo
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[photo]-0-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView])
		)
		// Photo height
		self.containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|[photo(260)][titleContainer]|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView, "titleContainer": self.titleContainer])
		)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
