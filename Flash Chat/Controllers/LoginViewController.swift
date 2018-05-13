//
//  LoginViewController.swift
//  Flash Chat
//
//  Created by Tran Thanh Bang on 2018/05/12.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataLogin()
    }
    
    //TODO: Button action
    @IBAction func onClickSignIn(_ sender: UIButton) {
        SVProgressHUD.show()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            SVProgressHUD.dismiss()
            if error != nil{
                print("login failed\(error!)")
            }else{
                print("login successed")
                self.saveDataLogin()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
    }
    
    
    //TODO: Save login information to userdefault
    func saveDataLogin(){
        UserDefaults.standard.set(emailTextField.text!, forKey: "email")
        UserDefaults.standard.set(passwordTextField.text!, forKey: "password")
    }
    
    func getDataLogin(){
        emailTextField.text = UserDefaults.standard.value(forKey: "email") as! String?
        passwordTextField.text = UserDefaults.standard.value(forKey: "password") as! String?
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
