//
//  ConfigViewController.swift
//  JeckyJogger
//
//  Created by Jecky on 14-10-7.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

import UIKit

class ConfigViewController: BaseViewController, UITextFieldDelegate {

    var weightTextField:UITextField?
    var heightTextField:UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Config"

        heightTextField = UITextField()
        heightTextField?.frame = CGRectMake(20, 20, CGRectGetWidth(self.view.frame)-40, 30)
        heightTextField!.borderStyle = .RoundedRect
        heightTextField!.placeholder = NSLocalizedString("Please input your height", comment: "")
        heightTextField!.autocorrectionType = .Yes
        heightTextField!.returnKeyType = .Done
        heightTextField!.clearButtonMode = .WhileEditing
        self.view.addSubview(heightTextField!)
        
        weightTextField = UITextField()
        weightTextField?.frame = CGRectMake(20, CGRectGetMaxY(heightTextField!.frame)+20, CGRectGetWidth(self.view.frame)-40, 30)
        weightTextField!.borderStyle = .RoundedRect
        weightTextField!.placeholder = NSLocalizedString("Please input your weight", comment: "")
        weightTextField!.autocorrectionType = .Yes
        weightTextField!.returnKeyType = .Done
        weightTextField!.clearButtonMode = .WhileEditing
        self.view.addSubview(weightTextField!)
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !textField.text.isEmpty {
            if textField == heightTextField!{                
                var heightStr =  NSString(string: heightTextField!.text) as NSString
                JoggerManager.shareInstance().saveHeight(heightStr.floatValue)
            }else if textField == weightTextField!{
                var weightStr =  NSString(string: weightTextField!.text) as NSString
                JoggerManager.shareInstance().saveHeight(weightStr.floatValue)
            }
        }
        return true
    }

}
