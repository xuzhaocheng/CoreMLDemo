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

class CameraViewController: UIViewController {

    var classificationRequest: VNRequest?

    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var modelTableView: UITableView!
    @IBOutlet weak var captureButton: UIButton!

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

        setupModel()
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

    func flashScreen() {
        self.previewView.cameraPreviewLayer.opacity = 0
        UIView.animate(withDuration: 0.25) {
            self.previewView.cameraPreviewLayer.opacity = 1
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
        self.resultViewController.name = name
        self.present(self.resultViewController, animated: true, completion: nil)
    }

    func beginCapturePhoto() {
        DispatchQueue.main.async {
            self.captureButton.isEnabled = false
        }
    }

    func endCapturePhoto() {
        DispatchQueue.main.async {
            self.captureButton.isEnabled = true
        }
    }

    func beginClassify() {
        self.stopSession()
        DispatchQueue.main.async {
            self.captureButton.isEnabled = false
        }
    }

    func endClassify() {
        self.resumeSession()
        DispatchQueue.main.async {
            self.captureButton.isEnabled = true
        }
    }


    func stopSession() {
        sessionQueue.async {
            self.session.stopRunning()
        }
    }

    func resumeSession() {
        sessionQueue.async {
            self.session.startRunning()
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
