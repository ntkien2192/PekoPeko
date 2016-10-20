//
//  ScanQRCodeViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MTBBarcodeScanner
import SwiftyJSON

class ScanQRCodeViewController: UIViewController {
    
    @IBOutlet weak var scanView: UIView!
    
    var scaner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewConfig()
    }
    
    func viewConfig() {
        scaner = MTBBarcodeScanner(metadataObjectTypes: [AVMetadataObjectTypeQRCode], previewView: scanView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScan()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let scaner = scaner {
            scaner.stopScanning()
        }
    }
    
    func startScan() {
        if let scaner = scaner {
            MTBBarcodeScanner.requestCameraPermission(success: { (success) in
                if success {
                    scaner.startScanning(resultBlock: { (codes) in
                        
                        if let codes = codes {
                            if codes.count != 0 {
                                scaner.stopScanning()
                                if let data = (codes.first as! AVMetadataMachineReadableCodeObject).stringValue.data(using: String.Encoding.utf8) {
                                    let qrCode = QRCode(json: JSON(data: data))
                                    self.loadCardList(qrCode: qrCode)
                                }
                                
                            }
                        }
                        }, error: nil)
                }
            })
        }
    }
    
    func loadCardList(qrCode: QRCode) {
        let addPointViewController = UIStoryboard(name: AddPointViewController.storyboardName, bundle: nil).instantiateViewController(withIdentifier: AddPointViewController.identify) as! AddPointViewController
        addPointViewController.qrCode = qrCode
        addPointViewController.delegate = self
        addPointViewController.isScan = true
        
        if let topController = AppDelegate.topController() {
            topController.present(addPointViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ScanQRCodeViewController: AddPointViewControllerDelegate {
    func pointAdded(point: Point?) {
        if let point = point {
            let messageView = MessageView(frame: view.bounds)
            if let honeyPot = point.honeyPot {
                if honeyPot == 0 {
                    messageView.message = "Tổng hoá đơn của bạn không đủ lớn để nhận điểm"
                } else {
                    messageView.message = "Bạn đã nhận được \(honeyPot) điểm"
                }
            }
            messageView.setButtonClose("Đóng", action: {
                if !AuthenticationStore().isLogin {
                    HomeTabbarController.sharedInstance.logOut()
                }
            })
            self.view.addFullView(view: messageView)
        }
    }
}
