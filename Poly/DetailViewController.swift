//
//  DetailViewController.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/6/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

	weak var detailDescriptionLabel: UILabel!
	var story: Story?
	let scrollView = UIScrollView()
	let webView = UIWebView()
	let photoView = UIImageView()
	let navTitleView = UIScrollView()
	let titleLabel = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.view.backgroundColor = UIColor.white
		
		// Don't lay things out under the navbar
		self.edgesForExtendedLayout = []
		
		// Put everything in a View inside a Scroll View
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.delegate = self
		self.view.addSubview(scrollView)
		let containerView = UIView()
		containerView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(containerView)
		
		// Pin scroll view to edges of view
		self.view.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-0-[scrollView]-0-|",
			options: [],
			metrics: nil,
			views: ["scrollView": scrollView])
		)
		self.view.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-0-[scrollView]-0-|",
			options: [],
			metrics: nil,
			views: ["scrollView": scrollView])
		)
		// Pin container view to edges of scroll view
		scrollView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-0-[container]-0-|",
			options: [],
			metrics: nil,
			views: ["container": containerView])
		)
		scrollView.addConstraint(scrollView.widthAnchor.constraint(equalTo: containerView.widthAnchor))
		
		// Kicker
		let kickerLabel = UILabel()
		kickerLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(kickerLabel)
		kickerLabel.textAlignment = .left
		kickerLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
		kickerLabel.textColor = UIColor(red: 0.8617, green: 0.1186, blue: 0.0198, alpha: 1)
		kickerLabel.numberOfLines = 0
		kickerLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of kicker
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[kicker]-20-|",
			options: [],
			metrics: nil,
			views: ["kicker": kickerLabel])
		)
		// Get kicker text
		kickerLabel.text = self.story!.kicker
		
		// Title
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(titleLabel)
		titleLabel.textAlignment = .left
		titleLabel.text = self.story!.title
		titleLabel.font = UIFont(name: "Georgia", size: 28)
		titleLabel.numberOfLines = 0
		titleLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of title
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[title]-20-|",
			options: [],
			metrics: nil,
			views: ["title": titleLabel])
		)
		
		// Photo
		self.photoView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(photoView)
		// Maximum photo height
		self.photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[photo(<=200)]",
			options: [],
			metrics: nil,
			views: ["photo": photoView])
		)
		self.photoView.contentMode = UIViewContentMode.scaleAspectFill
		self.photoView.clipsToBounds = true
		self.photoView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
		// Download photo
		let photoPath = self.story!.photoURL
		if photoPath != "" {
			let url = URL(string: "https://poly.rpi.edu" + photoPath)
			let request = URLRequest(url: url!)
			let session = URLSession(configuration: URLSessionConfiguration.default)
			_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
				if error == nil {
					DispatchQueue.main.async {
						self.photoView.image = UIImage(data: data!)
					}
				}
			}).resume()
		}
		
		// Photo byline
		let photoBylineLabel = UILabel()
		photoBylineLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(photoBylineLabel)
		photoBylineLabel.textAlignment = .right
		photoBylineLabel.text = self.story!.photoByline
		photoBylineLabel.font = UIFont(name: "AvenirNext-Regular", size: 13)
		photoBylineLabel.numberOfLines = 0
		photoBylineLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of byline
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[byline]-20-|",
			options: [],
			metrics: nil,
			views: ["byline": photoBylineLabel])
		)
		
		// Photo caption
		let photoCaptionLabel = UILabel()
		photoCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(photoCaptionLabel)
		photoCaptionLabel.textAlignment = .left
		photoCaptionLabel.text = self.story!.photoCaption
		photoCaptionLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
		photoCaptionLabel.numberOfLines = 0
		photoCaptionLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of byline
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[caption]-20-|",
			options: [],
			metrics: nil,
			views: ["caption": photoCaptionLabel])
		)
		
		// Author and job
		let authorLabel = UILabel()
		authorLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(authorLabel)
		
		let authorAndJob = NSMutableAttributedString()
		if let authorName = self.story?.author {
			let authorAttrs = [NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 14)]
			let authorString = NSAttributedString(string: authorName, attributes: authorAttrs)
			authorAndJob.append(authorString)
			
			if let authorJob = self.story?.authorTitle, authorJob != "" {
				let jobAttrs = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 13)]
				let jobString = NSAttributedString(string: ", " + authorJob, attributes: jobAttrs)
				authorAndJob.append(jobString)
			}
			
		}
		
		authorLabel.attributedText = authorAndJob
		authorLabel.numberOfLines = 0
		authorLabel.textAlignment = .left
		authorLabel.lineBreakMode = .byWordWrapping
		// Spacing on sides of author
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-20-[author]-20-|",
			options: [],
			metrics: nil,
			views: ["author": authorLabel])
		)
		
		// Article
		self.webView.delegate = self
		self.webView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(webView)
		// Construct HTML string by concatenating article CSS and article content from poly.rpi.edu API
		var HTMLString = "<html><head><style>body {font-family: Georgia; margin: 20px; line-height: 27px; font-size: 18px;}</style></head><body>"
		HTMLString += self.story!.article
		HTMLString += "</body></html>"
		self.webView.loadHTMLString(HTMLString, baseURL: nil)
		self.webView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
		self.webView.scrollView.isScrollEnabled = false
		self.webView.backgroundColor = UIColor.white
		
		// Vertical layout
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[kicker]-10-[title]-10-[author]-14-[photo]-1-[byline]-4-[caption]-0-[article]-10-|",
			options: [],
			metrics: nil,
			views: ["photo": self.photoView,
			        "title": titleLabel,
			        "kicker": kickerLabel,
			        "article": self.webView,
			        "author": authorLabel,
			        "byline": photoBylineLabel,
			        "caption": photoCaptionLabel])
		)
		
		// Add share button to navigation bar
		let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
		self.navigationItem.rightBarButtonItem = shareButton
		
		// Show photo view on photo tap
		let photoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPhoto))
		photoView.addGestureRecognizer(photoTapRecognizer)
		photoView.isUserInteractionEnabled = true
		
		// Scroll in title in navigation bar
		self.navTitleView.frame = CGRect(x: 0, y: 0, width: 200, height: 44)
		self.navTitleView.contentSize = CGSize(width: 0, height: 88)
		self.navTitleView.isUserInteractionEnabled = false
		self.view.addSubview(self.navTitleView)
		
		let navTitleLabel = UILabel(frame: CGRect(x: 0, y: 44, width: self.navTitleView.frame.width, height: 44))
		navTitleLabel.text = titleLabel.text
		navTitleLabel.textAlignment = .center
		navTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
		navTitleLabel.textColor = .white
		navTitleLabel.numberOfLines = 2
		navTitleLabel.lineBreakMode = .byWordWrapping
		navTitleView.addSubview(navTitleLabel)
		self.navigationItem.titleView = navTitleView
	}
	
	func share() {
		// Share the article with UIActivityViewController
		let shareURL = NSURL(string: self.story!.link)
		let activityViewController = UIActivityViewController(activityItems: [shareURL as Any], applicationActivities: nil)
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	func showPhoto() {
		// Show the story's photo in a new view
		let photoViewController = PhotoViewController()
		photoViewController.imageView.image = self.photoView.image
		self.present(photoViewController, animated: true, completion: nil)
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		let heightStr = self.webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")
		if let heightNum = NumberFormatter().number(from: heightStr!) {
			let height = CGFloat(heightNum) + 27
			self.webView.heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == self.scrollView {
			let titleLabelFrame = self.titleLabel.frame
			let inView = self.view.convert(titleLabelFrame, from: self.scrollView)
			let titleLabelOffset = -1 * inView.minY
			let contentOffset = CGPoint(x: 0, y: min(titleLabelOffset, 44))
			self.navTitleView.contentOffset = contentOffset
		}
	}
}

