//
//  VoucherTableViewCell.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 23/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import Haneke

protocol VoucherTableViewCellDelegate: class {
    func voucherTapped(voucher: Voucher?, completionHandler: @escaping (Bool) -> Void)
}

class VoucherTableViewCell: UITableViewCell {

    static let identify = "VoucherTableViewCell"
    
    weak var delegate: VoucherTableViewCellDelegate?
    
    @IBOutlet weak var viewContent: View!
    @IBOutlet weak var imageViewAvatar: ImageView!
    @IBOutlet weak var imageViewVoucherAvatar: ImageView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelVoucherTitle: UILabel!
    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelExtant: UILabel!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var labelShopAddress: UILabel!
    
    let border = CAShapeLayer()
    
    var voucher: Voucher? {
        didSet {
            if let voucher = voucher {
                if let image = voucher.image {
                    let cache = Shared.imageCache
                    let URL = NSURL(string: image)!
                    let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                    weak var _self = self
                    _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                        _self?.imageViewVoucherAvatar.image = image
                    })
                }
                
                if let title = voucher.title {
                    labelVoucherTitle.text = title
                }
                
                if let totalUses = voucher.totalUses {
                    self.totalUses = totalUses
                }
                
                if let maxUses = voucher.maxUses {
                    self.maxUses = maxUses
                }
                
                if let shop = voucher.shop {
                    if let avatarUrl = shop.avatarUrl {
                        let cache = Shared.imageCache
                        let URL = NSURL(string: avatarUrl)!
                        let fetcher = NetworkFetcher<UIImage>(URL: URL as URL)
                        weak var _self = self
                        _ = cache.fetch(fetcher: fetcher).onSuccess({ (image) in
                            _self?.imageViewAvatar.image = image
                        })
                    }
                    
                    if let fullName = shop.fullName {
                        labelShopName.text = fullName
                    }
                    
                    if let address = shop.address, let addressContent = address.addressContent {
                        labelShopAddress.text = addressContent
                    }
                }
            }
        }
    }
    
    var totalUses: Int = 0 {
        didSet {
            let attributedText = NSMutableAttributedString()
            let attribute1 = [NSFontAttributeName: UIFont.getFont(14), NSForegroundColorAttributeName: UIColor.colorBrown]
            let variety1 = NSAttributedString(string: "Đã sử dụng: ", attributes: attribute1)
            attributedText.append(variety1)
            let attribute2 = [NSFontAttributeName: UIFont.getBoldFont(14), NSForegroundColorAttributeName: UIColor.colorOrange]
            let variety2 = NSAttributedString(string: "\(totalUses)", attributes: attribute2)
            attributedText.append(variety2)
            
            labelUser.attributedText = attributedText
        }
    }
    
    var maxUses: Int = 0 {
        didSet {
            let attributedText = NSMutableAttributedString()
            let attribute1 = [NSFontAttributeName: UIFont.getFont(14), NSForegroundColorAttributeName: UIColor.colorBrown]
            let variety1 = NSAttributedString(string: "Còn lại: ", attributes: attribute1)
            attributedText.append(variety1)
            let attribute2 = [NSFontAttributeName: UIFont.getBoldFont(30), NSForegroundColorAttributeName: UIColor.colorOrange]
            let variety2 = NSAttributedString(string: "\(maxUses - totalUses)", attributes: attribute2)
            attributedText.append(variety2)
            
            let variety3 = NSAttributedString(string: " xuất", attributes: attribute1)
            attributedText.append(variety3)
            
            labelExtant.attributedText = attributedText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorder()
    }
    
    func setupBorder() {
        border.strokeColor = UIColor.colorOrange.cgColor
        border.fillColor = nil
        border.lineDashPattern = [5, 5]
        viewContent.layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = CGRect(x: 0, y: 0, width: self.bounds.width - 16, height: self.bounds.height - 8)
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius:10).cgPath
        border.frame = bounds
    }
    
    @IBAction func buttonCellTapped(_ sender: AnyObject) {
        weak var _self = self
        delegate?.voucherTapped(voucher: voucher, completionHandler: { (success) in
            if let _self = _self {
                if success {
                    _self.totalUses = _self.totalUses + 1
                    _self.maxUses = Int(_self.maxUses)
                }
            }
        })
    }
}
