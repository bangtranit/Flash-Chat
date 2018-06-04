//
//  RegisterViewController.swift
//  Flash Chat
//
//  Created by Tran Thanh Bang on 2018/05/12.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import AlertBar

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickRegisterAccount(_ sender: UIButton) {
        SVProgressHUD .show()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error ) in
            if error != nil{
                print(error!)
                AlertBar.show(type: .error, message: "Register failed. Please check email or password.")
            }
            else{
                print("register success")
                AlertBar.show(type: .success, message: "Login success.")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            SVProgressHUD .dismiss()
        }
    }
    
}
