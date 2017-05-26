//
//  QRScaner.swift
//  BillScaner
//
//  Created by Alexey Demedetskii on 5/26/17.
//  Copyright © 2017 Alexey Demedeckiy. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    struct ViewModel {
        var processPayload: (Data) -> Void
    }
    
    var viewModel = ViewModel { _ in }
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        let input: AVCaptureInput = try! AVCaptureDeviceInput(
            device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        )
        
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        guard let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            fatalError("Cannot instantiate preview layer")
        }
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.startRunning()
    }
    
    /// We need to stop it before animation will start.
    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!)
    {
        guard let metadataObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject]
            else { return }
        
        guard let qrCode = metadataObjects.first(where: { $0.type == AVMetadataObjectTypeQRCode })
            else { return }
        
        guard let data = qrCode.stringValue.data(using: .utf8) else { return }
        
        DispatchQueue.main.async { self.viewModel.processPayload(data) }
    }
}
