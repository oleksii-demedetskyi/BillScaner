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
        var codeSink: ((String) -> Void)?
    }
    
    var viewModel: ViewModel = ViewModel(codeSink: nil) {
        didSet {
            if isAppeared &&
                viewModel.codeSink != nil &&
                oldValue.codeSink == nil
            {
                captureSession.startRunning()
            }
            
            if isAppeared &&
                oldValue.codeSink != nil &&
                viewModel.codeSink == nil
            {
                captureSession.stopRunning()
            }
        }
    }
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        let input: AVCaptureInput = try! AVCaptureDeviceInput(
            device: AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        )
        
        captureSession.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        captureSession.addOutput(captureMetadataOutput)
        
        guard let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
            fatalError("Cannot instantiate preview layer")
        }
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
    }
    
    var isAppeared = false
    
    override func viewWillAppear(_ animated: Bool) {
        isAppeared = true
        if viewModel.codeSink != nil { captureSession.startRunning() }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isAppeared = false
        captureSession.stopRunning()
    }
    
    @nonobjc func captureOutput(captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [AnyObject]!,
                       fromConnection connection: AVCaptureConnection!) {
        
        guard let metadataObjects = metadataObjects as? [AVMetadataMachineReadableCodeObject]
            else { return }
        
        guard let qrCode = metadataObjects.first(where: { $0.type == AVMetadataObjectTypeQRCode })
            else { return }
        
        guard let sink = viewModel.codeSink else { return }
        
        sink(qrCode.stringValue)
    }
    
}
