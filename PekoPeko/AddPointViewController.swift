//
//  AddPointViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit

protocol AddPointViewControllerDelegate: class {
    func buttonAddpointTapped()
}

class AddPointViewController: BaseViewController {

    static let storyboardName = "Card"
    static let identify = "AddPointViewController"
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var textfieldCode1: Textfield!
    @IBOutlet weak var textfieldCode2: Textfield!
    @IBOutlet weak var textfieldCode3: Textfield!
    @IBOutlet weak var textfieldCode4: Textfield!
    @IBOutlet weak var textfieldCode5: Textfield!
    @IBOutlet weak var textfieldCode6: Textfield!
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonUserDiscountTapped(_ sender: AnyObject) {
        if (sender as! UISwitch).isOn {
            print("on")
        } else {
            print("off")
        }
    }
    
    @IBAction func buttonBackTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonHideKeyboardTapped(_ sender: AnyObject) {
        hideKeyboard()
    }
    
    @IBAction func buttonAddPointTapped(_ sender: AnyObject) {
    }
    
}

extension AddPointViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = string
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for i in 0..<tfs.count {
            if textField == tfs[i] {
                if (i + 1) < tfs.count {
                    if let textF = tfs[i + 1] {
                        textF.becomeFirstResponder()
                        return false
                    }
                } else {
                    hideKeyboard()
                }
                break
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tfs = [textfieldCode1, textfieldCode2, textfieldCode3, textfieldCode4, textfieldCode5, textfieldCode6]
        for tf in tfs {
            if let tf = tf {
                tf.layer.borderWidth = 0.5
            }
        }
    }
}
