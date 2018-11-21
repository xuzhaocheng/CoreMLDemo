//
//  ResultView.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/20/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView? {
        didSet {
            self.imageView?.layer.cornerRadius = 10
            self.imageView?.clipsToBounds = true
        }
    }

    var closeBlock: (() -> Void)?

    public var image: UIImage? {
        didSet {
            updateUI()
        }
    }

    public var name: String? {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        self.nameLabel?.text = name
        self.imageView?.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.closeBlock?()
        }
    }
}
