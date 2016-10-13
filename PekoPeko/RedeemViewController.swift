//
//  RedeemViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class RedeemViewController: UIViewController {
    
    @IBOutlet weak var naviItem: UINavigationItem!
    
    static let storyboardName = "Redeem"
    static let identify = "RedeemViewController"
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
