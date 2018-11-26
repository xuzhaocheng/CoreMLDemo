//
//  CameraViewController+CoreML.swift
//  CoreMLDemo
//
//  Created by Xu, Zhaocheng on 11/20/18.
//  Copyright © 2018 Xu, Zhaocheng. All rights reserved.
//

import Foundation
import Vision

extension CameraViewController {

    func classify(_ imageData: Data) {
        guard let image = CIImage(data: imageData) else {
            self.endClassify()
            return
        }

        self.curImageData = imageData

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            do {
                try handler.perform([self.classificationRequest!])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                self.endClassify()
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    func setupModel(_ modelName: String) {
        do {
            let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc")
            let model = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))

            let request = VNCoreMLRequest(model: model) { (request, error) in
                self.processClassifications(for: request, error: error)
            }

            request.imageCropAndScaleOption = .centerCrop
            self.classificationRequest = request
        } catch {

        }
    }

    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("unknow")
                self.endClassify()
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            if let classifications = results as? [VNClassificationObservation],
                let result = classifications.first {
                self.showResult(result)
            } else {
                self.endClassify()
            }

        }
    }

}
