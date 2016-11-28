//
//  PayViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol PayViewControllerDelegate: class {
    func closeView(success: Bool)
}

class PayViewController: UIViewController {

    static let storyboardName = "Redeem"
    static let storyboardID = "PayViewController"
    
    weak var delegate: PayViewControllerDelegate?
    
    @IBOutlet weak var webView: UIWebView!
    
    var payUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: ((payUrl ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")) {
            webView.loadRequest(URLRequest(url: url))
            webView.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonbackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PayViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url {
            if url.absoluteString.hasSuffix("#close-web-view") {
                self.dismiss(animated: true, completion: { 
                    self.delegate?.closeView(success: false)
                })
            }
            
            if url.absoluteString.hasSuffix("#close-web-view-success") {
                self.dismiss(animated: true, completion: {
                    self.delegate?.closeView(success: true)
                })
            }
        }
        return true
    }
}
