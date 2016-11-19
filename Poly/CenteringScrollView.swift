//
//  CenteringScrollView.swift
//  Poly
//
//  Created by Sidney Kochman on 11/18/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class CenteringScrollView: UIScrollView {

	// Keeps its first subview centered as it is zoomed out.
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// center the image as it becomes smaller than the size of the screen
		let boundsSize = self.bounds.size;
		var frameToCenter = self.subviews[0].frame
		
		// center horizontally
		if (frameToCenter.size.width < boundsSize.width) {
			frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
		} else {
			frameToCenter.origin.x = 0
		}
		
		// center vertically
		if (frameToCenter.size.height < boundsSize.height) {
			frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
		} else {
			frameToCenter.origin.y = 0;
		}
		
		self.subviews[0].frame = frameToCenter;
	}

}
