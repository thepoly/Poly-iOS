//
//  DecoderString.swift
//  Poly
//
//  Created by Sidney Kochman on 11/13/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class DecoderString {
	// Decodes HTML entities inside a string.
	
	static var cache = [String: String]()
	var htmlEncodedString = String()
	
	init(_ htmlEncodedString: String) {
		self.htmlEncodedString = htmlEncodedString
	}
	
	func decode() -> String {
		// memoize for performance
		if let cached = DecoderString.cache[self.htmlEncodedString] {
			return cached
		}
		
		var res: String
		
		guard let encodedData = self.htmlEncodedString.data(using: .utf8) else {
			res = htmlEncodedString
			DecoderString.cache[htmlEncodedString] = res
			return res
		}
		
		let attributedOptions: [String : Any] = [
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
			NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
		]
		
		do {
			let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
			res = attributedString.string
		} catch {
			print("Error: \(error)")
			res = htmlEncodedString
		}
		DecoderString.cache[htmlEncodedString] = res
		return res
	}
}
