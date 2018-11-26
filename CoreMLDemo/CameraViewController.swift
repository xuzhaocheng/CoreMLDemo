//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/14/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

enum CapturePhotoError: Error {
    case noImageData
}

func dispatch2MainThreadIfNeeded(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

class CameraViewController: UIViewController {

    var classificationRequest: VNRequest?

    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var captureButton: UIButton!
    
    @IBOutlet weak var settingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var settingTableViewBottomPadding: NSLayoutConstraint!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }

    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "session queue")
    var setupResult: SessionSetupResult = .success
    let photoOutput = AVCapturePhotoOutput()
    var photoCaptureProcessor: PhotoCaptureProcessor?
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!

    var curImageData: Data?

    var selectedIndex: Int = 0
    lazy var models: [String] = {
        if let url = Bundle.main.url(forResource: "Models", withExtension: "plist") {
            if let array = NSArray(contentsOf: url) as? [String] {
                return array
            }
        }

        return [String]()
    }()


    lazy var resultViewController: ResultViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        vc.closeBlock = {
            self.endClassify()
        }
        return vc
    }()
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingTableView.isUserInteractionEnabled = true
        self.settingTableView.layer.cornerRadius = 10
        self.settingTableView.layer.masksToBounds = true

        self.selectedIndex = 0
        setupModel(self.models.first!)
        setupCameraSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkSessionSetupResult()
    }

    @IBAction private func capturePhoto(_ photoButton: UIButton) {
        self.beginCapturePhoto()
        self.capturePhoto()
    }

    @IBAction func settingButtonClicked(_ sender: Any) {
        self.showBlurView(true)
        self.showSettingView(true)
    }

    @IBAction func tapOnView(_ sender: Any) {
        self.showSettingView(false)
        self.showBlurView(false)
    }

    func showSettingView(_ shown: Bool) {
        self.settingTableViewBottomPadding.constant = shown ? 0 : self.settingTableViewHeight.constant
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func flashScreen() {
        self.previewView.cameraPreviewLayer.opacity = 0
        UIView.animate(withDuration: 0.25) {
            self.previewView.cameraPreviewLayer.opacity = 1
        }
    }

    func showBlurView(_ shown: Bool) {
        guard shown == self.blurView.isHidden else {
            return
        }
        self.blurView.alpha = shown ? 0 : 1
        self.blurView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = shown ? 1 : 0
        }) { (finished) in
            if !shown {
                self.blurView.isHidden = true
            }
        }
    }

    func showResult(_ result: VNClassificationObservation) {
        
        guard let imageData = self.curImageData else {
            self.resumeSession()
            return
        }

        let name = String(result.identifier.split(separator: ",").first!)

        self.definesPresentationContext = true
        self.resultViewController.image = UIImage(data: imageData)
        self.resultViewController.name = name + "(" + String(format: "%.2f", result.confidence) + ")"
        self.present(self.resultViewController, animated: true, completion: nil)
    }

    func beginCapturePhoto() {
        DispatchQueue.main.async {
            self.captureButton.isEnabled = false
        }
    }

    func endCapturePhoto(_ error: Error? = nil) {
        if error != nil {
            DispatchQueue.main.async {
                self.captureButton.isEnabled = true
            }
        }
    }

    func beginClassify() {
        self.stopSession()
    }

    func endClassify() {
        self.resumeSession()
    }

    func stopSession() {
        dispatch2MainThreadIfNeeded {
            self.showBlurView(true)
        }
        sessionQueue.async {
            self.session.stopRunning()
        }
    }

    func resumeSession() {
        sessionQueue.async {
            self.session.startRunning()
        }
        dispatch2MainThreadIfNeeded {
            self.captureButton.isEnabled = true
            self.showBlurView(false)
        }
    }
}


extension CameraViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScaleUpPresentAnimation()
    }


    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScaleDownDismissAnimation()
    }
}
