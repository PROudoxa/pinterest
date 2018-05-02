//
//  ViewController.swift
//  PinterestV
//
//  Created by Alex Voronov on 28.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidLoginDataLabel: UILabel!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invalidLoginDataLabel.isHidden = true
        addToolBarToKeypad()
    }
}

// MARK: IBActions
extension LoginViewController {
    
    @IBAction func logInTapped(_ sender: UIButton) {
        
        guard let login = loginTextField.text, login != "",
            let password = passwordTextField.text, password != "" else {
                
                if sender.currentTitle == "use pinterest acc" {
                    performSegue(withIdentifier: "logInSegue", sender: nil)
                }
                return }
        
        // TODO: if invalid login or password:
        self.invalidLoginDataLabel.isHidden = false
        
        UIView.animate(withDuration: 3, delay: 0.5, options: [.curveLinear], animations: {
            self.invalidLoginDataLabel.alpha = 0
            
        }) { (finished) in
            self.invalidLoginDataLabel.isHidden = true
        }
        
        // TODO: if login successful save login+psw and change initial VC
        //UserDefaults.standard.setValue(true, forKey: "authenticatedUser")
        
        // TODO: implement different logic in order to login:
        // 1: login+password
        // 2: Oauth2
        if sender.currentTitle == "LOG IN" {
            //performSegue(withIdentifier: "logInSegue", sender: nil)
            
        } else if sender.currentTitle == "use pinterest acc" {
            performSegue(withIdentifier: "logInSegue", sender: nil)
            
        }
    }
}

// MARK: Private
extension LoginViewController {

    func addToolBarToKeypad() {
        //init toolbar
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.loginTextField.inputAccessoryView = toolbar
        self.passwordTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
}

