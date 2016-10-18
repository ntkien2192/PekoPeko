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
    
    var segmentControl: SMSegmentView?
    
    var shop: Shop?
    
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
        let appearance = SMSegmentAppearance()
        appearance.segmentOnSelectionColour = UIColor.clear
        appearance.segmentOffSelectionColour = UIColor.clear
        appearance.contentVerticalMargin = 15.0
        
        segmentControl = SMSegmentView(frame: segmentView.bounds, dividerColour: UIColor.clear, dividerWidth: 1.0, segmentAppearance: appearance)
        if let segmentControl = segmentControl {
            segmentControl.addTarget(self, action: #selector(ShopMenuViewController.selectSegmentInSegmentView), for: .valueChanged)
            
            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType1"), offSelectionImage: UIImage(named: "IconFoodType1Off"))
            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType2"), offSelectionImage: UIImage(named: "IconFoodType2Off"))
            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType3"), offSelectionImage: UIImage(named: "IconFoodType3Off"))
            segmentControl.addSegmentWithTitle(nil, onSelectionImage: UIImage(named: "IconFoodType4"), offSelectionImage: UIImage(named: "IconFoodType4Off"))
            segmentView.addSubview(segmentControl)
            segmentControl.translatesAutoresizingMaskIntoConstraints = false
            
            segmentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": segmentControl]))
            segmentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": segmentControl]))
        }

        
    }
    
    func selectSegmentInSegmentView() {
        if let segmentControl = segmentControl {
            print(segmentControl.selectedSegmentIndex)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
