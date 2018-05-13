//
//  FlashChatViewController.swift
//  Flash Chat
//
//  Created by Tran Thanh Bang on 2018/05/12.
//  Copyright © 2018年 Tran Thanh Bang. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class FlashChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputMessageViewHeightConstraint: NSLayoutConstraint!
    
    let cellIdentifier : String = "FlashChatCell"
    var heightOfKeyboard : Float = 226.0
    var arrayMessage : [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TODO: init method
    func initUI(){
        SVProgressHUD.show()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
        
        configureTableView()
        receiveMessage()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlashChatViewController.tableViewTapped(_:)))
        messageTableView.addGestureRecognizer(tapGesture)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(onClickSignOut))
        messageTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        SVProgressHUD.dismiss()
    }
    
    @objc func tableViewTapped(_ tapGesture: UITapGestureRecognizer) {
        //  Your code here
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            heightOfKeyboard = Float(keyboardSize.height)
            UIView.animate(withDuration: 0.2) {
                self.inputMessageViewHeightConstraint.constant = CGFloat(Float(50 + self.heightOfKeyboard))
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //TODO: Received Messages
    
    func receiveMessage(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let message = Message()
            message.messageBody = snapshotValue["MessageBody"]!
            message.sender = snapshotValue["Sender"]!
            self.arrayMessage.append(message)
            self.messageTableView .reloadData()
        }
    }
    
    
    //TODO: Button action
    
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
    
    @IBAction func onClickSendMessage(_ sender: UIButton) {
        view.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        let messageDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email,
                                 "MessageBody" : messageTextField.text!]
        messageDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            if error != nil{
                print(error!)
            }else{
                print("Message has been sent")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
        
    }
    
    
    //TODO: Table View
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FlashChatCell
        cell.messageLabel.text = arrayMessage[indexPath.row].messageBody
        cell.nameLabel.text = arrayMessage[indexPath.row].sender
        if cell.nameLabel.text != Auth.auth().currentUser?.email as String? {
            cell.nameLabel.textColor = UIColor.flatWhite()
        }else{
            cell.messageLabel.textAlignment = NSTextAlignment.right
            cell.nameLabel.textAlignment = NSTextAlignment.right
            cell.avatarImageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .reloadData()
    }
    
    //TODO: Textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.inputMessageViewHeightConstraint.constant = CGFloat(Float(50 + self.heightOfKeyboard))
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.inputMessageViewHeightConstraint.constant = 50
        }
    }
}
