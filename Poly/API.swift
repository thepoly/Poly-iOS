//
//  API.swift
//  Poly
//
//  Created by Sidney Kochman on 11/20/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import Foundation

class API {
	
	// Public data
	
	public var stories: [Story] {
		get {
			return self._stories
		}
	}
	
	public var categories: [Dictionary<String, AnyObject>] {
		get {
			return self._categories
		}
	}
	
	public var featuredStories: [Story] {
		get {
			return self._featuredStories
		}
	}
	
	// Notifications
	public static let storiesLoadComplete = Notification.Name("storiesLoadComplete")
	
	// Internal data
	private var _stories = [Story]()
	private var storiesLoaded = false
	private var _featuredStories = [Story]()
	private var featuredStoriesLoaded = false
	private var _categories = [Dictionary<String, AnyObject>]()
	private var categoriesLoaded = false
	
	init() {
		loadStories()
	}
	
	func notifyLoadComplete() {
		// Check that load is actually complete, and then send notification if it is
		
		if self.storiesLoaded && self.featuredStoriesLoaded && self.categoriesLoaded {
			// Send notification that load is complete
			let nc = NotificationCenter.default
			nc.post(Notification(name: API.storiesLoadComplete))
		}
	}
	
	func loadStories() {
		// Refresh all stories
		let url = URL(string: "https://poly.rpi.edu/wp-json/wp/v2/posts?per_page=30")
		let request = URLRequest(url: url!)
		let session = URLSession(configuration: URLSessionConfiguration.default)
		_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
			if error == nil {
				let json = try! JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
				var stories = self.parseStories(fromJSON: json)
				
				// Remove stories in PDF Archives category. Iterate in reverse so we can remove
				// stories by index without off-by-one errors.
				for (i, story) in stories.enumerated().reversed() {
					let categories = story.categories
					if categories.count == 1 {
						if categories.contains(10) {
							stories.remove(at: i)
						}
					}
				}
				
				self._stories = stories
				self.storiesLoaded = true
				
				self.notifyLoadComplete()
			}
		}).resume()
		
		// Refresh featured stories
		let featuredURL = URL(string: "https://poly.rpi.edu/wp-json/wp/v2/posts?filter[tag]=featured&per_page=3")
		let featuredRequest = URLRequest(url: featuredURL!)
		_ = session.dataTask(with: featuredRequest, completionHandler: {(data, response, error) -> Void in
			if error == nil {
				let json = try! JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
				self._featuredStories = self.parseStories(fromJSON: json)
				self.featuredStoriesLoaded = true
				
				self.notifyLoadComplete()
			}
		}).resume()
		
		// Refresh categories
		let categoriesURL = URL(string: "https://poly.rpi.edu/wp-json/wp/v2/categories")
		let categoriesRequest = URLRequest(url: categoriesURL!)
		_ = session.dataTask(with: categoriesRequest, completionHandler: {(data, response, error) -> Void in
			if error == nil {
				let json = try! JSONSerialization.jsonObject(with: data!) as! [Dictionary<String, AnyObject>]
				self._categories = json
				self.categoriesLoaded = true
				
				self.notifyLoadComplete()
			}
		}).resume()
	}
	
	private func parseStories(fromJSON json: Any) -> [Story] {
		var stories = [Story]()
		
		guard let jsonStories = json as? [Dictionary<String, AnyObject>] else {
			return stories
		}
		
		for jsonStory in jsonStories {
			guard
				let title = jsonStory["title"]?["rendered"] as? String,
				let author = jsonStory["AuthorName"] as? String,
				let authorTitle = jsonStory["AuthorTitle"] as? String,
				let article = jsonStory["content"]?["rendered"] as? String,
				let kicker = (jsonStory["Kicker"] as? String)?.uppercased(),
				let categories = jsonStory["categories"] as? [Int],
				let photoURL = jsonStory["Photo"] as? String,
				let photoByline = jsonStory["PhotoByline"] as? String,
				let photoCaption = jsonStory["PhotoCaption"] as? String,
				let link = jsonStory["link"] as? String
			else {
				continue
			}
			
			let story = Story(title: DecoderString(title).decode(),
			                  author: DecoderString(author).decode(),
			                  authorTitle: DecoderString(authorTitle).decode(),
			                  article: article,
			                  kicker: DecoderString(kicker).decode(),
			                  categories: categories,
			                  photoURL: photoURL,
			                  photoByline: DecoderString(photoByline).decode(),
			                  photoCaption: DecoderString(photoCaption).decode(),
			                  link: link)
			stories.append(story)
		}
		
		return stories
	}
}

struct Story {
	let title: String
	let author: String
	let authorTitle: String
	let article: String
	let kicker: String
	let categories: [Int]
	let photoURL: String
	let photoByline: String
	let photoCaption: String
	let link: String
}
