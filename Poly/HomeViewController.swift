//
//  MasterViewController.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/6/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	let api = API()
	
	var collectionView: UICollectionView?
	var featuredCollectionView: UICollectionView? = nil // for 3D Touch


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Put the Poly lettermark behind the table view
		let loadingFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		let loadingView = UIView(frame: loadingFrame)
		let loadingLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		loadingLogoView.image = UIImage(named: "Lettermark")
		loadingLogoView.layer.cornerRadius = 10
		loadingLogoView.layer.masksToBounds = true
		loadingLogoView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height / 2 - 40)
		loadingLogoView.alpha = 0.1
		loadingView.addSubview(loadingLogoView)
		//self.view.insertSubview(loadingView, at: 0)
		
		// BIG titles
//		self.navigationController?.navigationBar.prefersLargeTitles = true

		// Put Poly logo in navbar
		self.title = "The Polytechnic"
		let navBarLogoView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
		let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: navBarLogoView.frame.width, height: navBarLogoView.frame.height))
		logoView.image = UIImage(named: "Navigation Bar Logo")
		logoView.contentMode = UIViewContentMode.scaleAspectFit
		navBarLogoView.addSubview(logoView)
		self.navigationItem.titleView = navBarLogoView
		
		// Remove text from back button
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
		// Featured stories cell
		let featuredCollectionViewLayout = UICollectionViewFlowLayout()
		featuredCollectionViewLayout.scrollDirection = .horizontal
		self.featuredCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: featuredCollectionViewLayout)
		
		// Set up collection view
		let collectionViewLayout = UICollectionViewFlowLayout()
		collectionViewLayout.scrollDirection = .vertical
		collectionViewLayout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
		collectionViewLayout.minimumLineSpacing = 30
//		collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
		collectionViewLayout.estimatedItemSize = CGSize(width: self.view.bounds.width - 30, height: 200)
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
		self.collectionView!.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.9, alpha: 1)
		self.collectionView!.register(StoryCell.self, forCellWithReuseIdentifier: "StoryCell")
		self.collectionView!.register(StoryPhotoCell.self, forCellWithReuseIdentifier: "StoryPhotoCell")
		self.collectionView!.dataSource = self
		self.collectionView!.delegate = self
		
		self.view = self.collectionView
		
		// Wait for notification that story API load is complete
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(initialLoad), name: API.storiesLoadComplete, object: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	// MARK: - Table View
	
	@objc func initialLoad() {
		// Should be called after API has loaded data and sent notification
		
		// Reload table view and remove lettermark now that we've loaded data
		DispatchQueue.main.async {
			self.collectionView?.reloadData()
			//self.view.subviews[1].removeFromSuperview()
		}
	}

//	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		if indexPath.section == 0 {
//			let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedStoriesCell", for: indexPath) as! FeaturedStoriesCell
//			cell.masterViewController = self
//			self.featuredCollectionView = cell.collectionView // for 3D Touch
//			cell.reload()
//			return cell
//		}
//		let story = self.api.stories[indexPath.row]
//		var cell: StoryCell  // this is okay because StoryPhotoCell is a subclass of StoryCell
//
//		// If there is a photo, use StoryPhotoCell
//		let photoPath = story.photoURL
//		if photoPath == "" {
//			cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryCell
//		} else {
//			cell = tableView.dequeueReusableCell(withIdentifier: "StoryPhotoCell", for: indexPath) as! StoryPhotoCell
//
//			// Configure photo
//			let url = URL(string: "https://poly.rpi.edu" + photoPath)
//			let request = URLRequest(url: url!)
//			let session = URLSession(configuration: URLSessionConfiguration.default)
//			_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
//				if error == nil {
//					DispatchQueue.main.async {
//						(cell as! StoryPhotoCell).photoView.image = UIImage(data: data!)
//					}
//				}
//			}).resume()
//		}
//
//		// Title
//		cell.titleLabel.text = story.title
//
//		// Kicker
//		cell.kickerLabel.text = story.kicker
//
//		// Author
//		cell.authorLabel.text = story.author
//
//		return cell
//	}
	
//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let story = self.api.stories[indexPath.row]
//		let controller = DetailViewController()
//		controller.story = story
//		self.navigationController?.pushViewController(controller, animated: true)
//	}

}

// MARK: - 3D Touch

extension HomeViewController: UIViewControllerPreviewingDelegate {
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = self.collectionView?.indexPathForItem(at: location), let cellAttributes = self.collectionView?.layoutAttributesForItem(at: indexPath) {
			previewingContext.sourceRect = cellAttributes.bounds
			let detail = DetailViewController()
			detail.story = self.api.stories[indexPath.row]
			return detail
		}
		
		// Handle featured stories cell
		// Adjust location to take scroll position into account
//		let scrolledLocation = self.featuredCollectionView!.convert(location, from: self.view)
//		if let indexPath = self.featuredCollectionView!.indexPathForItem(at: scrolledLocation) {
//
//			// Convert cell frame to take scroll position into account
//			let frame = self.featuredCollectionView!.layoutAttributesForItem(at: indexPath)!.frame
//			let scrolledFrame = self.featuredCollectionView!.convert(frame, to: self.view)
//
//			previewingContext.sourceRect = scrolledFrame
//			let detail = DetailViewController()
//			detail.story = self.api.featuredStories[indexPath.row]
//			return detail
//		}
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
	}
}

// MARK: - Collection view

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		// 3D Touch Peek and Pop
		registerForPreviewing(with: self, sourceView: cell)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.api.stories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell: StoryCell
		let story = self.api.stories[indexPath.row]
		
		// Category
		var category = ""
		for categoryObj in self.api.categories {
			// THIS NEEDS TO BE FIXED IN CASE THERE ARE NO CATEGORIES FOR A POST
			if categoryObj["id"] as! Int == story.categories[0] {
				category = categoryObj["name"] as! String
			}
		}
		//cell.categoryLabel.text = category.uppercased()
		
		// Configure photo
		let photoPath = story.photoURL
		if photoPath == "" {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCell", for: indexPath) as! StoryCell
		} else {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryPhotoCell", for: indexPath) as! StoryPhotoCell

			// Configure photo
			let url = URL(string: "https://poly.rpi.edu" + photoPath)
			let request = URLRequest(url: url!)
			let session = URLSession(configuration: URLSessionConfiguration.default)
			_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
				if error == nil {
					DispatchQueue.main.async {
						(cell as! StoryPhotoCell).photoView.image = UIImage(data: data!)
					}
				}
			}).resume()
		}
		
		// Set attributes
		cell.titleLabel.text = story.title
		cell.kickerLabel.text = story.kicker
		cell.setWidth(self.view.frame.width - 30)
		cell.isHeightCalculated = false
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let story = self.api.stories[indexPath.row]
		let controller = DetailViewController()
		controller.story = story
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//		// center cells if they don't span the whole width of the collection view
//
//		let cellCount = self.api.featuredStories.count
//		if cellCount == 0 {
//			// no cells!
//			return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//		}
//		let cellWidth = 200 // from FeaturedStoriesCell
//		let collectionViewWidth = collectionView.frame.width
//
//		let totalCellWidth = cellWidth * cellCount
//		let totalSpacingWidth = 10 * (cellCount - 1)
//		let totalWidth = totalCellWidth + totalSpacingWidth
//
//		if CGFloat(totalWidth) > collectionViewWidth {
//			// return normal insets if cells fill the width
//			return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//		}
//
//		let leftInset = (collectionViewWidth - CGFloat(totalWidth)) / 2;
//		let rightInset = leftInset
//
//		return UIEdgeInsets(top: 10, left: leftInset, bottom: 10, right: rightInset)
//	}
	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		let story = self.api.stories[indexPath.row]
//		// Is there a photo?
//		let photoPath = story.photoURL
//		if photoPath != "" {
//			return CGSize(width: self.view.bounds.width - 30, height: 360)
//		}
//		return CGSize(width: self.view.bounds.width - 30, height: 160)
//	}
	
	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
		// insets need to be recalculated after rotate because cells may not fill width
		self.featuredCollectionView?.reloadSections(IndexSet(integer: 0))
	}
}
