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
                                    let point = Point(json: JSON(data: data))
                                    self.loadCardList(point: point)
                                }
                                
                            }
                        }
                        }, error: nil)
                }
            })
        }
    }
    
    func loadCardList(point: Point) {
        
        if let cardID = point.shopID {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
