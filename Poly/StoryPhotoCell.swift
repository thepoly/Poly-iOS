//
//  StoryCell.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/7/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class StoryPhotoCell: StoryCell {
	
	var photoView = UIImageView()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier!)

		
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
		self.photoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
		
		// Vertical layout with photo
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[kicker]-10-[photo]-10-[title]-20-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView, "title": self.titleLabel, "kicker": self.kickerLabel])
		)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
