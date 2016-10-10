//
//  UserUpdateInfoViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 10/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import ImagePicker

class UserUpdateInfoViewController: UIViewController {

    static let storyboardName = "Login"
    static let identify = "UserUpdateInfoViewController"
    
    @IBOutlet weak var buttonAvatar: Button!
    @IBOutlet weak var buttonTakePicture: Button!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var buttonShowHidePassword: UIButton!
    
    @IBOutlet weak var viewInputName: View!
    @IBOutlet weak var viewInputCode: View!
    @IBOutlet weak var buttonSubmit: Button!
    
    var defaultConstraintValue: CGFloat?
    
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configView()
    }
    
    func configView() {
        defaultConstraintValue = constraintTop.constant
    }
    
    
    /// Take Pictures Alert Button
    ///
    /// - parameter sender: buttonAvatar / buttonTakePicture
    @IBAction func buttonTakePicturesTapped(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takeNewPictureAction = UIAlertAction(title: "Chụp ảnh mới", style: .default) { (action) in
            
            let imagePickerController = ImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.imageLimit = 1
            Configuration.doneButtonTitle = "Sử dụng"
            Configuration.noImagesTitle = "Không có bức ảnh nào trong thư mục này"
            self.present(imagePickerController, animated: true, completion: nil)
            
            
//            self.imagePicker = UIImagePickerController()
//            
//            if let imagePicker = self.imagePicker {
//                imagePicker.delegate = self
//                imagePicker.sourceType = .camera
//                imagePicker.cameraCaptureMode = .photo
//                imagePicker.allowsEditing = true
//                self.present(imagePicker, animated: true, completion: nil)
//            }
        }
        alertController.addAction(takeNewPictureAction)
        
        let choosePictureAction = UIAlertAction(title: "Chọn ảnh từ thư viện", style: .default) { (action) in
            
        }
        alertController.addAction(choosePictureAction)
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        alertController.addAction(cancleAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        slideDownView()
    }
    
    func submit() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideDownView() {
        view.endEditing(true)
        if let defaultConstraintValue = defaultConstraintValue {
            if constraintTop.constant != defaultConstraintValue {
                constraintTop.constant = defaultConstraintValue
                view.setNeedsLayout()
                buttonAvatar.isHidden = false
                buttonTakePicture.isHidden = false
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                    self.buttonAvatar.alpha = 1.0
                    self.buttonTakePicture.alpha = 1.0
                }
            }
        }
    }
    
    func hideLoginField() {
        let animation = "fadeOut"
        
        viewInputName.animation = animation
        viewInputName.animate()
        
        viewInputCode.animation = animation
        viewInputCode.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
    
    func showLoginField() {
        let animation = "fadeInUp"
        
        viewInputName.animation = animation
        viewInputName.animate()
        
        viewInputCode.animation = animation
        viewInputCode.animate()
        
        buttonSubmit.animation = animation
        buttonSubmit.animate()
    }
}

extension UserUpdateInfoViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) { 
            
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
}

extension UserUpdateInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            viewInputName.layer.borderWidth = 2.0
            break
        case 1:
            viewInputCode.layer.borderWidth = 2.0
            break
        default:
            break
        }
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -40, d40: -90, d50: -65, d55: 0) {
            if constraintTop.constant != constraintValue {
                constraintTop.constant = constraintValue
                view.setNeedsLayout()
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.buttonAvatar.alpha = 0.0
                    self.buttonTakePicture.alpha = 0.0
                    }, completion: { _ in
                        self.buttonAvatar.isHidden = true
                        self.buttonTakePicture.isHidden = true
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewInputName.layer.borderWidth = 0.5
        viewInputCode.layer.borderWidth = 0.5
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
}
