//
//  ScaleUpPresentAnimation.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/21/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import Foundation
import UIKit

class ScaleUpPresentAnimation: NSObject {

}

class ScaleDownDismissAnimation: NSObject {

}

extension ScaleUpPresentAnimation: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)

        toView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        toView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                        toView.alpha = 1
                        toView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }

    }

}


extension ScaleDownDismissAnimation: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let containerView = transitionContext.containerView
        containerView.addSubview(fromView)

        fromView.transform = CGAffineTransform(scaleX: 1, y: 1)
        fromView.alpha = 1

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            fromView.alpha = 0
            fromView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
}
