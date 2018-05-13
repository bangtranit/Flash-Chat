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
            }
            else{
                print("register success")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            SVProgressHUD .dismiss()
        }
    }
    
}
