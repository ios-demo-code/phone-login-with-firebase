//
//  ViewController.swift
//  PhoneNumberAuthenticationWithFirebase
//
//  Created by Soeng Saravit on 12/17/18.
//  Copyright © 2018 Soeng Saravit. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().languageCode = "km";
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        let phoneNumber = phoneNumberTextField.text
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            // Sign in using the verificationID and the code sent to the user
            // ...
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            let alert = UIAlertController(title: "Verify code", message: "Please enter code sent to your phone number", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "123456"
            })
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                let credential = PhoneAuthProvider.provider().credential(
                    withVerificationID: verificationID!,
                    verificationCode: alert.textFields![0].text!)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        // ...
                        print(error.localizedDescription)
                    }else{
                        // User is signed in
                        print("===> User is logged in")
                    }
                    
                }
            })
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}

