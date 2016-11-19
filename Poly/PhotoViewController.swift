//
//  PhotoViewController.swift
//  Poly
//
//  Created by Sidney Kochman on 11/18/16.
//  Copyright © 2016 The Rensselaer Polytechnic. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
	
	let scrollView = CenteringScrollView()
	let imageView = UIImageView()
	var interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Swipe down to dismiss
		let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
		self.view.addGestureRecognizer(swipeGesture)
		self.transitioningDelegate = self
		
		self.view.backgroundColor = .black
		self.view.addSubview(scrollView)
		
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
		scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
		
		let minScale = min(self.view.bounds.size.width / self.imageView.image!.size.width, self.view.bounds.size.height / self.imageView.image!.size.height)
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 1
		scrollView.delegate = self
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		
		scrollView.addSubview(self.imageView)
		scrollView.zoomScale = minScale

		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.imageView.contentMode = .scaleAspectFit

    }
	
	// MARK: - Scroll view

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
		let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
		
		self.imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
		                                y: scrollView.contentSize.height * 0.5 + offsetY);
	}

    // MARK: - Navigation
	
	func handleSwipe(sender: UIPanGestureRecognizer) {
		
		let percentThreshold: CGFloat = 0.25
		
		let translation = sender.translation(in: self.view)
		let verticalMovement = translation.y / self.view.bounds.height
		let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
		let downwardMovementPercentage = fminf(downwardMovement, 1.0)
		let progress = CGFloat(downwardMovementPercentage)
		
		switch sender.state {
		case .began:
			self.interactor.hasStarted = true
			self.dismiss(animated: true, completion: nil)
		case .changed:
			self.interactor.shouldFinish = progress > percentThreshold
			self.interactor.update(progress)
		case .cancelled:
			self.interactor.hasStarted = false
			self.interactor.cancel()
		case .ended:
			self.interactor.hasStarted = false
			if self.interactor.shouldFinish {
				self.interactor.finish()
			} else {
				self.interactor.cancel()
			}
		default:
			break
		}
	}
}

extension PhotoViewController: UIViewControllerTransitioningDelegate {
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return DismissAnimator()
	}
	func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		if self.interactor.hasStarted {
			return self.interactor
		}
		return nil
	}
}

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.6
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromVC = transitionContext.viewController(forKey: .from) as! PhotoViewController
		let toVC = transitionContext.viewController(forKey: .to)!
		let containerView = transitionContext.containerView
		
		containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
		
		let screenBounds = UIScreen.main.bounds
		let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
		let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
		               delay: 0,
		               options: [.curveLinear],
		               animations: {
						   fromVC.scrollView.frame = finalFrame
						   fromVC.view.backgroundColor = .clear
					   },
		               completion: { _ in
						   transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
					   })
	}
}

class Interactor: UIPercentDrivenInteractiveTransition {
	var hasStarted = false
	var shouldFinish = false
}
