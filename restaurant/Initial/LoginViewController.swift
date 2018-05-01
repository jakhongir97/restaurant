//
//  ViewController.swift
//  restaurant
//
//  Created by Jahongir Nematov on 3/14/18.
//  Copyright © 2018 Jahongir Nematov. All rights reserved.
//

import UIKit
import FirebaseAuth
import CTKFlagPhoneNumber
import RxSwift
import RxCocoa


class LoginViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumberTextField: CTKFlagPhoneNumberTextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var phoneNumber = Variable<String>("")
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func setupView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.parentViewController = self
        phoneNumberTextField.setFlag(with: "UZ")
        phoneNumberTextField.flagSize = CGSize(width: 30, height: 30)
        phoneNumberTextField.borderStyle = .none
        phoneNumberTextField.setBottomLine(borderColor: .orange)
        
        
        nextButton.layer.cornerRadius = 20
        nextButton.isEnabled = false
        nextButton.alpha = 0.6
        
        
        _ = phoneNumberTextField.rx.text.map{$0 ?? "" }.bind(to: phoneNumber)
        
        phoneNumber.asObservable().subscribe(onNext: { [unowned self] number in
            if self.phoneNumberTextField.isValid(phoneNumber: number) {
                self.nextButton.isEnabled = true
                self.nextButton.alpha = 1
                self.phoneNumberTextField.resignFirstResponder()
                
            } else {
                self.nextButton.isEnabled = false
                self.nextButton.alpha = 0.6
            }
            
        }).disposed(by: disposeBag)
        
    
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        
        guard let phoneNumber = phoneNumberTextField.getFormattedPhoneNumber() else {return}
        
        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.set(self.phoneNumberTextField.text, forKey: "phoneNumberFormatted")
        UserDefaults.standard.synchronize()
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.synchronize()
            
            

        }
        
        
        
    }
    
    @IBAction func dissmissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
   
    
    
    
}
