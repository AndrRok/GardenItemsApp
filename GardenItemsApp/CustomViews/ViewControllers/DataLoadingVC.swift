//
//  DataLoadingVC.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit

class DataLoadingVC: UIViewController {
    private lazy var containerView = UIView(frame: view.bounds)
    
    public func showLoadingView() {
        DispatchQueue.main.async { [self] in
            view.addSubview(containerView)
            containerView.backgroundColor   = .systemBackground
            containerView.alpha             = 0
            UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ])
            activityIndicator.startAnimating()
        }
    }
    
    
    public func dismissLoadingView() {
        DispatchQueue.main.async{
            self.containerView.removeFromSuperview()
        }
    }
}

