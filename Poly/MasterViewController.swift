//
//  MasterViewController.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/6/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

	var stories = [Dictionary<String, AnyObject>]()
	var featuredStories = [Dictionary<String, AnyObject>]()
	var categories = [Dictionary<String, AnyObject>]()
	
	var featuredCollectionView: UICollectionView? = nil // for 3D Touch


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Hide table view until we have loaded some data
		self.tableView.subviews[0].alpha = 0
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
		self.tableView.insertSubview(loadingView, at: 0)
		
		// Set Poly logo in navbar
		let navBarLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 3, height: 33))
		navBarLogoView.image = UIImage(named: "Navigation Bar Logo")
		navBarLogoView.contentMode = UIViewContentMode.scaleAspectFit
		self.navigationItem.titleView = navBarLogoView
		
		// Remove text from back button
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
		// 3D Touch Peek and Pop
		registerForPreviewing(with: self, sourceView: self.view)
		
		// Hide table view cell separator
		self.tableView.separatorStyle = .none
		
		// Table View cells
		self.tableView.register(StoryCell.classForCoder(), forCellReuseIdentifier: "StoryCell")
		self.tableView.register(StoryPhotoCell.classForCoder(), forCellReuseIdentifier: "StoryPhotoCell")
		self.tableView.register(FeaturedStoriesCell.classForCoder(), forCellReuseIdentifier: "FeaturedStoriesCell")
		self.tableView.estimatedRowHeight = 200
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
		// Featured stories cell
		let collectionViewLayout = UICollectionViewFlowLayout()
		collectionViewLayout.scrollDirection = .horizontal
		self.featuredCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
		
		self.refreshStories()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Deselect row on transition back to view
		if let indexPath = self.tableView.indexPathForSelectedRow {
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	func refreshStories() {
		// Refresh all stories
		let url = URL(string: "https://poly.rpi.edu/wp-json/wp/v2/posts?per_page=30")
		let request = URLRequest(url: url!)
		let session = URLSession(configuration: URLSessionConfiguration.default)
		_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
			if error == nil {
				let json = try! JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
				self.stories = json
				
				// Remove stories in PDF Archives category. Iterate in reverse so we can remove
				// stories by index without off-by-one errors.
				for (i, story) in self.stories.enumerated().reversed() {
					if let categories = story["categories"] as? [Int] {
						if categories.count == 1 {
							if categories.contains(10) {
								self.stories.remove(at: i)
							}
						}
					}
				}
				
				DispatchQueue.main.async {
					self.tableView.reloadData()
					
					// Unhide table view now that we've loaded data
					UIView.animate(withDuration: 0.2, animations: {
						self.tableView.subviews[1].alpha = 1
					})
				}
			}
		}).resume()
		
		// Refresh featured stories
		let featuredURL = URL(string: "https://poly.rpi.edu/wp-json/wp/v2/posts?filter[tag]=featured&per_page=3")
		let featuredRequest = URLRequest(url: featuredURL!)
		_ = session.dataTask(with: featuredRequest, completionHandler: {(data, response, error) -> Void in
			if error == nil {
				let json = try! JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
				self.featuredStories = json
				
				DispatchQueue.main.async {
					// For some reason, reloadData doesn't work, but this does (we only have one section):
					self.featuredCollectionView?.reloadSections(IndexSet(integer: 0))
				}
			}
		}).resume()
		
		// Refresh categories
		let categoriesURL = URL(string: "https://poly.rpi.edu/wp-json/wp/v2/categories")
		let categoriesRequest = URLRequest(url: categoriesURL!)
		_ = session.dataTask(with: categoriesRequest, completionHandler: {(data, response, error) -> Void in
			if error == nil {
				// this is bad because self.categories MUST be set before we can lay out the featured stories. please fix this
				let json = try! JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
				self.categories = json
			}
		}).resume()
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return stories.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedStoriesCell", for: indexPath) as! FeaturedStoriesCell
			cell.masterViewController = self
			self.featuredCollectionView = cell.collectionView // for 3D Touch
			cell.reload()
			return cell
		}
		let story = stories[indexPath.row]
		var cell: StoryCell  // this is okay because StoryPhotoCell is a subclass of StoryCell
		
		// If there is a photo, use StoryPhotoCell
		let photoPath = story["Photo"]! as! String
		if photoPath == "" {
			cell = tableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as! StoryCell
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: "StoryPhotoCell", for: indexPath) as! StoryPhotoCell
			
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
		
		// Title
		let title = story["title"]!["rendered"] as! String
		cell.titleLabel.text = DecoderString(title).decode()
		
		// Kicker
		let kicker = (story["Kicker"] as! String).uppercased()
		cell.kickerLabel.text = DecoderString(kicker).decode()
		
		// Author
		let author = story["AuthorName"]! as! String
		cell.authorLabel.text = DecoderString(author).decode()
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let story = stories[indexPath.row]
		let controller = DetailViewController()
		controller.detailItem = story
		self.navigationController?.pushViewController(controller, animated: true)
	}

}

// MARK: - 3D Touch

extension MasterViewController: UIViewControllerPreviewingDelegate {
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = tableView.indexPathForRow(at: location) {
			previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
			let detail = DetailViewController()
			if indexPath.section != 0 {
				// Handle cells that aren't the featured stories cell (which is in section 0)
				detail.detailItem = stories[indexPath.row]
				return detail
			}
		}
		
		// Handle featured stories cell
		// Adjust location to take scroll position into account
		let scrolledLocation = self.featuredCollectionView!.convert(location, from: self.view)
		if let indexPath = self.featuredCollectionView!.indexPathForItem(at: scrolledLocation) {
			
			// Convert cell frame to take scroll position into account
			let frame = self.featuredCollectionView!.layoutAttributesForItem(at: indexPath)!.frame
			let scrolledFrame = self.featuredCollectionView!.convert(frame, to: self.view)
			
			previewingContext.sourceRect = scrolledFrame
			let detail = DetailViewController()
			detail.detailItem = featuredStories[indexPath.row]
			return detail
		}
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
	}
}

// MARK: - Collection view

extension MasterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return featuredStories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedStoryCell", for: indexPath) as! FeaturedStoryCell
		let story = featuredStories[indexPath.row]
		
		// Title
		let title = story["title"]!["rendered"] as! String
		cell.titleLabel.text = DecoderString(title).decode()
		
		// Category
		var category = ""
		for categoryObj in self.categories {
			// THIS NEEDS TO BE FIXED IN CASE THERE ARE NO CATEGORIES FOR A POST
			if categoryObj["id"] as! Int == (story["categories"] as! [Int])[0] {
				category = categoryObj["name"] as! String
			}
		}
		cell.categoryLabel.text = category.uppercased()
		
		// Configure photo
		let photoPath = story["Photo"]! as! String
		if photoPath != "" {
			let url = URL(string: "https://poly.rpi.edu" + photoPath)
			let request = URLRequest(url: url!)
			let session = URLSession(configuration: URLSessionConfiguration.default)
			_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
				if error == nil {
					DispatchQueue.main.async {
						cell.photoView.image = UIImage(data: data!)
					}
				}
			}).resume()
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let story = featuredStories[indexPath.row]
		let controller = DetailViewController()
		controller.detailItem = story
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		// center cells if they don't span the whole width of the collection view
		
		let cellCount = featuredStories.count
		if cellCount == 0 {
			// no cells!
			return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
		let cellWidth = 200 // from FeaturedStoriesCell
		let collectionViewWidth = collectionView.frame.width
		
		let totalCellWidth = cellWidth * cellCount
		let totalSpacingWidth = 10 * (cellCount - 1)
		let totalWidth = totalCellWidth + totalSpacingWidth
		
		if CGFloat(totalWidth) > collectionViewWidth {
			// return normal insets if cells fill the width
			return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		}
		
		let leftInset = (collectionViewWidth - CGFloat(totalWidth)) / 2;
		let rightInset = leftInset
		
		return UIEdgeInsets(top: 10, left: leftInset, bottom: 10, right: rightInset)
	}
	
	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
		// insets need to be recalculated after rotate because cells may not fill width
		self.featuredCollectionView?.reloadSections(IndexSet(integer: 0))
	}
}
