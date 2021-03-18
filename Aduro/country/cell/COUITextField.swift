//
//  COUITextField.swift : CodesOrbitUITextField
//  Eptah
//
//  Created by Work on 12/07/2019.
//  Copyright © 2019 Work. All rights reserved.
//

import Foundation
import UIKit

protocol COUITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
}

class COUITextField: UITextField, UITextFieldDelegate {
    
    var isCreditCardTextField = false
    var isExpirayDateTextField =  false
    var isCvvField = false
    var isMobileNumberField = false
    var isVerificationCodeTextField = false
    
    var shouldReturn = true
    var textFieldDelegate: COUITextFieldDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupTextField()
        self.delegate = self
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        self.delegate = self
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        _ = super.textRect(forBounds: bounds)
        var x: CGFloat = 20
        
        if isVerificationCodeTextField {
            x = 10
        }
        
        if self.rightView != nil {
            let rect = CGRect(x: x, y: 0, width: bounds.size.width - 60, height: bounds.size.height)
            return rect
            
        }
        
        let rect = CGRect(x: x, y: 0, width: bounds.size.width - 20, height: bounds.size.height)
        return rect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        var x: CGFloat = 20

        if isVerificationCodeTextField {
            x = 10
        }
        
        if self.rightView != nil {
            let rect = CGRect(x: x, y: 0, width: bounds.size.width - 60, height: bounds.size.height)
            return rect
        }
        
        let rect = CGRect(x: x, y: 0, width: bounds.size.width - 20, height: bounds.size.height)
        return rect
    }
    
    func setupTextField() {
     //   self.font = UIFont.appThemeFontWithSize(17.0)
//        self.borderColor = UIColor.clear
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        self.borderStyle = .none
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = true
        self.keyboardAppearance = .dark
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    
    func displayError() {
        self.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    }
}

extension COUITextField {
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if !shouldReturn {
            return false
        }
        
        self.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        let currentLength: Int = currentText.count
        
        if isVerificationCodeTextField {
            
            if currentLength == 5 {
                textField.resignFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.borderColor = UIColor.lightGray
        self.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        textFieldDelegate?.textFieldDidBeginEditing(textField)
        
        if isMobileNumberField && textField.text == "" {
            textField.text = "+92"
        }
        
        if isVerificationCodeTextField {
            //textField.font = UIFont.appThemeFontWithSize(25.0)
            //textField.textAlignment = .center
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.borderColor = UIColor.clear
        self.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        textFieldDelegate?.textFieldDidEndEditing(textField)
    }
}
