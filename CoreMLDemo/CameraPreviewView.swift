//
//  CameraPreviewView.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/19/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }

        return layer
    }

    var session: AVCaptureSession? {
        get {
            return cameraPreviewLayer.session
        }
        set {
            cameraPreviewLayer.session = newValue
        }
    }

    // MARK: UIView
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
