//
//  StoryCell.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/7/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class StoryCell: UITableViewCell {
	
	var kickerLabel = UILabel()
	var titleLabel = UILabel()
	var photoView = UIImageView()
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier!)
		
		self.backgroundView?.backgroundColor = UIColor.white
		
		// Cell separator line
		self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
		
		// Kicker
		self.kickerLabel.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.kickerLabel)
		self.kickerLabel.textAlignment = .left
		self.kickerLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
		self.kickerLabel.textColor = UIColor(red: 0.8617, green: 0.1186, blue: 0.0198, alpha: 1)
		self.kickerLabel.numberOfLines = 0
		self.kickerLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of kicker
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[kicker]-20-|",
			options: [],
			metrics: nil,
			views: ["kicker": self.kickerLabel])
		)
		
		// Photo
		self.photoView.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.photoView)
		// Maximum photo height
		self.photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[photo(<=200)]",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView])
		)
		self.photoView.contentMode = UIViewContentMode.scaleAspectFill
		self.photoView.clipsToBounds = true
		// Zero spacing on sides of photo
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[photo]-0-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView])
		)
		
		// Title
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.titleLabel)
		self.titleLabel.textAlignment = .left
		self.titleLabel.font = UIFont(name: "Georgia", size: 28)
		self.titleLabel.numberOfLines = 0
		self.titleLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of title
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[title]-20-|",
			options: [],
			metrics: nil,
			views: ["title": self.titleLabel])
		)
		
		// Vertical layout
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
