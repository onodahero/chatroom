//
//  ViewController.swift
//  chatroom
//
//  Created by 斧田洋人 on 2018/03/11.
//  Copyright © 2018年 斧田洋人. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var db: Firestore!
    var username: String = ""
    var roomId: Int = 0
    var roomRef: CollectionReference!
    var messagesdic: [[String:Any]] = []
    
    var messageTableView: UITableView!
    var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        print(username, roomId)
        roomRef = db.collection("rooms")

        messageTableView = UITableView(frame: CGRect(x: 0, y: 70, width: self.view.bounds.width, height: self.view.bounds.height - 170))
        messageTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        messageTableView.delegate = self
        messageTableView.dataSource = self
        self.view.addSubview(messageTableView)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(ViewController.done))
        toolbar.setItems([doneItem], animated: true)
        
        messageTextField = UITextField(frame: CGRect(x: 139, y: 599, width: 97, height: 30))
        messageTextField.inputAccessoryView = toolbar
        view.addSubview(messageTextField)
        print("room\(roomId)")
        roomRef.document("room\(roomId)").collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { messageSnapshot, error in
            guard let snap = messageSnapshot else{
                print("Error fetching document: \(error!)")
                return
            }
            let source = snap.metadata.hasPendingWrites ? "Local" : "Server"
            print(source)
            snap.documentChanges.forEach{ diff in
                print("New message: \(diff.document.data())")
                self.messagesdic.append(diff.document.data())
                self.messageTableView.reloadData()
                self.messageTableView.scrollToRow(at: IndexPath(row: self.messagesdic.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
                print(self.messagesdic)
                

            }
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesdic.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if messagesdic != nil {
            cell.textLabel!.text = "\(messagesdic[indexPath.row]["user"]! as! String)" + ":" + "\(messagesdic[indexPath.row]["message"]! as! String)"
        }
        return cell
    }
    
     func done() {
        if self.messageTextField.text != ""{
            let message = messageTextField.text!
            let timestamp = Timestamp.init()
            print(timestamp)
            roomRef.document("room\(roomId)").collection("messages").addDocument(data: [
                "message":message,
                "user":username,
                "timestamp":timestamp
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            messageTextField.text = ""
            messageTextField.endEditing(true)
        }
    }
    @IBAction func backHome(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

