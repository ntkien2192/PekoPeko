//
//  SettingViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 13/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import  NVActivityIndicatorView

class SettingViewController: UIViewController {

    @IBOutlet weak var buttonAvatar: Button!
    @IBOutlet weak var buttonTakePicture: Button!
    @IBOutlet weak var activityUploadData: NVActivityIndicatorView!
    
    var imagePicker: UIImagePickerController?
    var avatar: UIImage? {
        didSet {
            if let avatar = avatar {
                activityUploadData.startAnimating()
                buttonTakePicture.isHidden = true
                buttonAvatar.isHidden = true
                UserStore.updateAvatar(avatar, completionHandler: { (imageUrl, error) in
                    self.activityUploadData.stopAnimating()
                    self.buttonTakePicture.isHidden = false
                    self.buttonAvatar.isHidden = false
                    guard error == nil else {
                        return
                    }
                    self.buttonAvatar.setImage(url: imageUrl ?? "")
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Take Pictures Alert Button
    ///
    /// - parameter sender: buttonAvatar / buttonTakePicture
    @IBAction func buttonTakePicturesTapped(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takeNewPictureAction = UIAlertAction(title: "Chụp ảnh mới", style: .default) { (action) in
            
            self.imagePicker = UIImagePickerController()
            
            if let imagePicker = self.imagePicker {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.allowsEditing = true
                
                imagePicker.navigationBar.backgroundColor = UIColor.colorYellow
                imagePicker.navigationBar.tintColor = UIColor.colorBrown
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.colorBrown]
                let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 20.0))
                view.backgroundColor = UIColor.colorYellow
                imagePicker.view.addSubview(view)
                imagePicker.view.bringSubview(toFront: view)
                view.translatesAutoresizingMaskIntoConstraints = false
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        alertController.addAction(takeNewPictureAction)
        
        let choosePictureAction = UIAlertAction(title: "Chọn ảnh từ thư viện", style: .default) { (action) in
            self.imagePicker = UIImagePickerController()
            
            if let imagePicker = self.imagePicker {
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                imagePicker.navigationBar.backgroundColor = UIColor.colorYellow
                imagePicker.navigationBar.tintColor = UIColor.colorBrown
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.colorBrown]
                let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: 20.0))
                view.backgroundColor = UIColor.colorYellow
                imagePicker.view.addSubview(view)
                imagePicker.view.bringSubview(toFront: view)
                view.translatesAutoresizingMaskIntoConstraints = false
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]));
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                imagePicker.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": view]))
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(choosePictureAction)
        
        let cancleAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        
        present(alertController, animated: true, completion: nil)
    }

}

extension SettingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.avatar = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
