//
//  LoadingView.swift
//  BluetoothTest
//
//  Created by Nicolas Nascimento on 15/02/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import UIKit

final class LoadingComponent {
    
    // MARK: - Private
    private let blurViewTag = 1234
    private let activityIndicatorTag = 5678
    private let activityIndicatorZPosition = CGFloat(1000)
    private let targetView: UIView
    
    // MARK: - Initilization
    init(targetView: UIView) {
        self.targetView = targetView
    }
}


extension LoadingComponent {
    
    var isAnimating: Bool {
        return targetView.viewWithTag(activityIndicatorTag) != nil || targetView.viewWithTag(blurViewTag) != nil
    }
    
    func addLoadingIndicator() {
        let activityIndicator = targetView.viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView ?? UIActivityIndicatorView(activityIndicatorStyle: .gray)
        let blurView = targetView.viewWithTag(blurViewTag) as? UIVisualEffectView ?? UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        blurView.tag = blurViewTag
        activityIndicator.tag = activityIndicatorTag
        
        // Avoid unwanted constraints
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        targetView.addSubview(activityIndicator)
        targetView.addSubview(blurView)
        
        activityIndicator.layer.zPosition = activityIndicatorZPosition
        blurView.layer.zPosition = activityIndicator.layer.zPosition - 1
        
        // Set auto layout if needed
        if activityIndicator.constraints.isEmpty {
            activityIndicator.centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
        }
        
        if blurView.constraints.isEmpty {
            blurView.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
            blurView.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
            blurView.leftAnchor.constraint(equalTo: targetView.leftAnchor).isActive = true
            blurView.rightAnchor.constraint(equalTo: targetView.rightAnchor).isActive = true
        }
        
        if !activityIndicator.isAnimating {
            activityIndicator.startAnimating()
        }
    }
    
    func removeLoadingIndicators() {
        
        // Remove Indicator
        for activityIndicator in targetView.subviews.filter({ $0 is UIActivityIndicatorView }) as? [UIActivityIndicatorView] ?? [] {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
        // Remove Blur View
        guard let blurView = targetView.viewWithTag(blurViewTag) else { return }
        UIView.animate(withDuration: 0.2, animations: { blurView.alpha = 0.0 }) { _ in
            blurView.removeFromSuperview()
        }
    }
}

