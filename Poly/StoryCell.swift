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
	var authorLabel = UILabel()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier!)
		
		self.backgroundView?.backgroundColor = UIColor.white
		
		// Accessibility identifier for UI automation
		self.accessibilityIdentifier = "story-cell"
		
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
		
		// Author
		self.authorLabel.translatesAutoresizingMaskIntoConstraints = false
		self.contentView.addSubview(self.authorLabel)
		self.authorLabel.textAlignment = .left
		self.authorLabel.font = UIFont(name: "AvenirNext-Bold", size: 14)
//		self.authorLabel.textColor = UIColor(red: 0.8617, green: 0.1186, blue: 0.0198, alpha: 1)
		self.authorLabel.numberOfLines = 0
		self.authorLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of author
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[author]-20-|",
			options: [],
			metrics: nil,
			views: ["author": self.authorLabel])
		)
		
		// Vertical layout
		self.contentView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[kicker]-10@750-[title]-10-[author]-14-|",  // priority of 750 allows StoryPhotoCell to override it
			options: [],
			metrics: nil,
			views: ["title": self.titleLabel, "kicker": self.kickerLabel, "author": self.authorLabel])
		)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
