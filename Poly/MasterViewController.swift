//
//  MasterViewController.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/6/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIViewControllerPreviewingDelegate {

	var stories = [Dictionary<String, AnyObject>]()


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Set Poly logo in navbar
		let navBarLogoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 3, height: 33))
		navBarLogoView.image = UIImage(named: "Navigation Bar Logo")
		navBarLogoView.contentMode = UIViewContentMode.scaleAspectFit
		self.navigationItem.titleView = navBarLogoView
		
		// Remove text from back button
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		
		// 3D Touch Peek and Pop
		registerForPreviewing(with: self, sourceView: self.view)
		
		// Table View cells
		self.tableView.register(StoryCell.classForCoder(), forCellReuseIdentifier: "StoryCell")
		self.tableView.register(StoryPhotoCell.classForCoder(), forCellReuseIdentifier: "StoryPhotoCell")
		self.tableView.estimatedRowHeight = 200
		self.tableView.rowHeight = UITableViewAutomaticDimension
		
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
				}
			}
		}).resume()
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return stories.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> StoryCell {
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
		cell.titleLabel.text = String(htmlEncodedString: title)
		
		// Kicker
		let kicker = (story["Kicker"] as! String).uppercased()
		cell.kickerLabel.text = String(htmlEncodedString: kicker)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let story = stories[indexPath.row]
		let controller = DetailViewController()
		controller.detailItem = story
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: - 3D Touch
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		if let indexPath = tableView.indexPathForRow(at: location) {
			previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
			let detail = DetailViewController()
			detail.detailItem = stories[indexPath.row]
			return detail
		}
		return nil
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
	}
}
