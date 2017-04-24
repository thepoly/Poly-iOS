//
//  FeaturedStoriesCell.swift
//  Poly
//
//  Created by Sidney Kochman on 11/13/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class FeaturedStoriesCell: UITableViewCell {
	
	var collectionView: UICollectionView?
	var masterViewController: HomeViewController? {
		didSet {
			// All the data is in MasterViewController (for now... hopefully...)
			self.collectionView!.dataSource = self.masterViewController
			self.collectionView!.delegate = self.masterViewController
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// Set content to UICollectionView of featured stories
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
		layout.estimatedItemSize = CGSize(width: 200, height: 170)
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
		layout.minimumInteritemSpacing = 10
		self.collectionView = UICollectionView(frame: self.contentView.bounds, collectionViewLayout: layout)
		
		
		collectionView!.register(FeaturedStoryCell.self, forCellWithReuseIdentifier: "FeaturedStoryCell")
		collectionView!.backgroundColor = .white
		collectionView!.showsHorizontalScrollIndicator = false
		self.contentView.heightAnchor.constraint(equalToConstant: 190).isActive = true // cell height + 20
		
		// Speed up reload animations
		self.collectionView!.layer.speed = 4

		self.contentView.addSubview(collectionView!)
		collectionView!.reloadData()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.collectionView?.frame = self.contentView.bounds
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func reload() {
		UIView.performWithoutAnimation {
			self.collectionView?.reloadSections(IndexSet(integer: 0))
		}
	}
}
