//
//  AddPointViewController.swift
//  PekoPeko
//
//  Created by Nguyễn Trung Kiên on 14/10/2016.
//  Copyright © 2016 hungrybear. All rights reserved.
//

import UIKit
import TSCurrencyTextField

protocol AddPointViewControllerDelegate: class {
    func buttonAddpointTapped()
}

class AddPointViewController: BaseViewController {

    static let storyboardName = "Redeem"
    static let identify = "AddPointViewController"
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var textfieldCode1: Textfield!
    @IBOutlet weak var textfieldCode2: Textfield!
    @IBOutlet weak var textfieldCode3: Textfield!
    @IBOutlet weak var textfieldCode4: Textfield!
    @IBOutlet weak var textfieldCode5: Textfield!
    @IBOutlet weak var textfieldCode6: Textfield!
    
    @IBOutlet weak var textfieldMoney: TSCurrencyTextField!
    
    var defaultConstraintValue: CGFloat?
    
    var card: Card?
    var point: Point?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewConfig() {
        super.viewConfig()
        textfieldMoney.rightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textfieldMoney.rightViewMode = UITextFieldViewMode.always
        textfieldMoney.layer.cornerRadius = 5.0
        textfieldMoney.currencyNumberFormatter.locale = Locale.init(identifier: "en_VN")
        textfieldMoney.currencyNumberFormatter.currencySymbol = ""
        textfieldMoney.amount = NSNumber(value: 0.00)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
        if let defaultConstraintValue = defaultConstraintValue {
            if constraintTop.constant != defaultConstraintValue {
                constraintTop.constant = defaultConstraintValue
                view.setNeedsLayout()
                weak var _self = self
                UIView.animate(withDuration: 0.2) {
                    _self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultConstraintValue = constraintTop.constant
        loadPointInfo()
    }
    
    func loadPointInfo() {
        if let card = card {
            if let shopName = card.shopName {
                labelTitle.text = shopName
                labelName.text = shopName
            }
            
            if let shopAddress = card.shopAddress {
                labelAddress.text = shopAddress
            }
        }
        
        if let point = point {
            if let cardID = point.shopID {
                
                CardStore.getCard(cardID: cardID, completionHandler: { (card, error) in
                    guard error == nil else {
                        return
                    }
                    
                    if let card = card {
                        self.card = card
                    }
                })
            }
        }
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
        self.view.endEditing(true)
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
        
        if let constraintValue = DeviceConfig.getConstraintValue(d35: -40, d40: -200, d50: -65, d55: 0) {
            if constraintTop.constant != constraintValue {
                constraintTop.constant = constraintValue
                view.setNeedsLayout()
                weak var _self = self
                UIView.animate(withDuration: 0.2, animations: {
                    _self?.view.layoutIfNeeded()
                })
            }
        }
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
