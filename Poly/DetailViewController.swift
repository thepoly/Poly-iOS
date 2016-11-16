//
//  DetailViewController.swift
//  The Poly
//
//  Created by Sidney Kochman on 11/6/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {

	weak var detailDescriptionLabel: UILabel!
	var detailItem: Dictionary<String, AnyObject>?
	let webView = UIWebView()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.view.backgroundColor = UIColor.white
		
		// Don't lay things out under the navbar
		self.edgesForExtendedLayout = []
		
		// Put everything in a View inside a Scroll View
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
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
		let kicker = (self.detailItem?["Kicker"] as! String).uppercased()
		kickerLabel.text = DecoderString(kicker).decode()
		
		// Title
		let titleLabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(titleLabel)
		titleLabel.textAlignment = .left
		let title = self.detailItem?["title"]?["rendered"] as! String
		titleLabel.text = DecoderString(title).decode()
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
		let photoView = UIImageView()
		photoView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(photoView)
		// Maximum photo height
		photoView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:[photo(<=200)]",
			options: [],
			metrics: nil,
			views: ["photo": photoView])
		)
		photoView.contentMode = UIViewContentMode.scaleAspectFill
		photoView.clipsToBounds = true
		photoView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
		// Download photo
		let photoPath = self.detailItem?["Photo"]! as! String
		if photoPath != "" {
			let url = URL(string: "https://poly.rpi.edu" + photoPath)
			let request = URLRequest(url: url!)
			let session = URLSession(configuration: URLSessionConfiguration.default)
			_ = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
				if error == nil {
					DispatchQueue.main.async {
						photoView.image = UIImage(data: data!)
					}
				}
			}).resume()
		}
		
		// Photo byline
		let photoBylineLabel = UILabel()
		photoBylineLabel.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(photoBylineLabel)
		photoBylineLabel.textAlignment = .right
		let photoByline = self.detailItem?["PhotoByline"] as! String
		photoBylineLabel.text = DecoderString(photoByline).decode()
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
		let photoCaption = self.detailItem?["PhotoCaption"] as! String
		photoCaptionLabel.text = DecoderString(photoCaption).decode()
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
		if let authorName = self.detailItem?["AuthorName"] as? String {
			let authorNameDecoded = DecoderString(authorName).decode()
			let authorAttrs = [NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 14)]
			let authorString = NSAttributedString(string: authorNameDecoded, attributes: authorAttrs)
			authorAndJob.append(authorString)
			
			if let authorJob = (self.detailItem?["AuthorTitle"] as? String), authorJob != "" {
				let authorJobDecoded = DecoderString(", " + authorJob).decode()
				let jobAttrs = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 13)]
				let jobString = NSAttributedString(string: authorJobDecoded, attributes: jobAttrs)
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
		HTMLString += self.detailItem?["content"]?["rendered"] as! String
		HTMLString += "</body></html>"
		self.webView.loadHTMLString(HTMLString, baseURL: nil)
		self.webView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
		self.webView.scrollView.isScrollEnabled = false
		self.webView.backgroundColor = UIColor.white
		
		// Vertical layout
		containerView.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-15-[kicker]-10-[title]-10-[author]-14-[photo]-1-[byline]-4-[caption]-0-[article]-20-|",
			options: [],
			metrics: nil,
			views: ["photo": photoView,
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
	}
	
	func share() {
		// Share the article with UIActivityViewController
		let shareURL = NSURL(string: self.detailItem!["link"] as! String)
		let activityViewController = UIActivityViewController(activityItems: [shareURL as Any], applicationActivities: nil)
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		let heightStr = self.webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")
		if let heightNum = NumberFormatter().number(from: heightStr!) {
			let height = CGFloat(heightNum) + 27
			self.webView.heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
}

