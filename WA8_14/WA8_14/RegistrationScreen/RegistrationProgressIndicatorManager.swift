//
//  RegistrationProgressIndicatorManager.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import Foundation

extension RegistrationViewController: ProgressSpinnerDelegate {
    
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
