//
//  ShopMenuViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 18/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class ShopMenuViewController: BaseViewController {

    static let storyboardName = "Shop"
    static let identify = "ShopMenuViewController"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var segmentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewConfig() {
        super.viewConfig()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        getShopMenuItem()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setSegmentView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    func getShopMenuItem() {
        
    }
    
    func setSegmentView() {
        
        _ = [UIImage(named: "IconFoodType1Off"), UIImage(named: "IconFoodType2Off"), UIImage(named: "IconFoodType3Off"), UIImage(named: "IconFoodType4Off")]
        _ = [UIImage(named: "IconFoodType1"), UIImage(named: "IconFoodType2"), UIImage(named: "IconFoodType3"), UIImage(named: "IconFoodType4")]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
