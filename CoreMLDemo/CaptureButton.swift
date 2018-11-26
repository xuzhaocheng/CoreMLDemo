//
//  CaptureButton.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/22/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import Foundation
import UIKit

class CaptureButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }

    func setUp() {
        self.addTarget(self, action: #selector(scaleDown), for: .touchDown)
        self.addTarget(self, action: #selector(scaleUp), for: .touchUpInside)
    }

    @objc
    func scaleUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = .identity
        }, completion: nil)
    }

    @objc
    func scaleDown() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
}
