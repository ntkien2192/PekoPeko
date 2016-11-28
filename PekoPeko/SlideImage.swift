//
//  SlideImage.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 28/11/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

class SlideImage: UIView {

    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    
    var images = [UIImage]()
    
    var isImageView1 = true
    var isSlide = false
    
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(imageView1)
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": imageView1]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": imageView1]))
        
        addSubview(imageView2)
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": imageView2]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": imageView2]))
        
        imageView1.backgroundColor = UIColor.clear
        imageView2.backgroundColor = UIColor.clear
        
        imageView2.alpha = 0
        bringSubview(toFront: imageView1)
    }

    func setImage(data: [UIImage]) {
        images.append(contentsOf: data)
        
        imageView1.image = images[0]
        if !isSlide {
            isSlide = true
            slide()
        }
        
    }
    
    func slide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            if self.index == self.images.count - 1 {
                self.index = 0
            } else {
                self.index = self.index + 1
            }
            
            self.changeImage(imageNext: self.images[self.index])
            
            self.slide()
        }
    }
    
    func changeImage(imageNext: UIImage) {
        if isImageView1 {
            isImageView1 = false
            imageView2.alpha = 0
            imageView2.image = imageNext
            bringSubview(toFront: imageView2)
            UIView.animate(withDuration: 2, animations: {
                self.imageView2.alpha = 1
            })
        } else {
            isImageView1 = true
            imageView1.alpha = 0
            imageView1.image = imageNext
            bringSubview(toFront: imageView1)
            UIView.animate(withDuration: 2, animations: {
                self.imageView1.alpha = 1
            })
        }
    }
}
