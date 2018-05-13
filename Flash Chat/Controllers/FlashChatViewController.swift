//
//  FlashChatViewController.swift
//  Flash Chat
//
//  Created by Tran Thanh Bang on 2018/05/12.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import Firebase
class FlashChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(onClickSignOut))

    }
    
    @IBAction func onClickSignOut(_ sender: UIButton) {
        print("sign out")
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Has any problem so you can't sign out right now")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
