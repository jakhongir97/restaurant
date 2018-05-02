//
//  VerificationViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 4/24/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import FirebaseAuth



class VerificationViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField1.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(textField : UITextField ){
        self.errorLabel.isHidden = true
        
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case textField1:
                textField2.becomeFirstResponder()
            case textField2:
                textField3.becomeFirstResponder()
            case textField3:
                textField4.becomeFirstResponder()
            case textField4:
                textField5.becomeFirstResponder()
            case textField5:
                textField6.becomeFirstResponder()
            case textField6:
                textField6.resignFirstResponder()
                nextButton.isEnabled = true
                nextButton.alpha = 1
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case textField1:
                textField1.becomeFirstResponder()
            case textField2:
                textField1.becomeFirstResponder()
            case textField3:
                textField2.becomeFirstResponder()
            case textField4:
                textField3.becomeFirstResponder()
            case textField5:
                textField4.becomeFirstResponder()
            case textField6:
                textField5.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func setupView() {
        nextButton.layer.cornerRadius = 20
        nextButton.isEnabled = false
        nextButton.alpha = 0.6
        
        guard let phoneNumberFormatted = UserDefaults.standard.string(forKey: "phoneNumberFormatted") else { return }
        
        phoneNumberLabel.text = phoneNumberFormatted
        
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        
        textField1.setBottomLine(borderColor: .lightGray)
        textField2.setBottomLine(borderColor: .lightGray)
        textField3.setBottomLine(borderColor: .lightGray)
        textField4.setBottomLine(borderColor: .lightGray)
        textField5.setBottomLine(borderColor: .lightGray)
        textField6.setBottomLine(borderColor: .lightGray)
        
        
        textField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textField5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        textField6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
    }

    @IBAction func nextAction(_ sender: Any) {
        
        var verificationString = String(textField1.text!)
        verificationString += String(textField2.text!)
        verificationString += String(textField3.text!)
        verificationString += String(textField4.text!)
        verificationString += String(textField5.text!)
        verificationString += String(textField6.text!)
        
        let verificationCode = verificationString
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {return}
        
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        

        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                self.errorLabel.isHidden = false
                return
            }
            
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeStoryboard") as! HomeViewController
            self.navigationController?.pushViewController(vc,animated: true)

            
        }
        
    }
    
   

}
