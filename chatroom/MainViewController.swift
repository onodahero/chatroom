//
//  MainViewController.swift
//  chatroom
//
//  Created by 斧田洋人 on 2018/03/28.
//  Copyright © 2018年 斧田洋人. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CellDelegate{
    
    var username = ""
    var roomId = 0
    var db: Firestore!
    var roomRef: CollectionReference!
    var query: Query!
    var querySnapshots: [QueryDocumentSnapshot] = []
    var newQuerySnapshots: [QueryDocumentSnapshot] = []
    var roomData: [Int] = []
    var isCreate: Bool = false
    
    var tableview: UITableView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        roomRef = db.collection("rooms")
        
        roomRef.addSnapshotListener { roomSnapshot, error in
            guard let snap = roomSnapshot else{
                print("Error fetching document: \(error!)")
                return
            }
            snap.documentChanges.forEach{ diff in
                print("New massage: \(diff.document.data())")
                self.roomData.append(diff.document.data()["room"] as! Int)
            }
        }

        // Do any additional setup after loading the view.
        
      //  querySnapshots[0].data()["room"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        roomRef = db.collection("rooms")
        roomRef.getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.querySnapshots.append(document)                    
                }
                self.tableview.reloadData()
                
            }
        }
        
        tableview = UITableView(frame: CGRect(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.height - 200))
        let nib: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "TableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        cell.roomLabel.text = "room\(roomData[indexPath.row])"
//        let enterbutton = UIButton(frame: cell.frame)
//        enterbutton.setTitle("入室", for: .normal)
//        enterbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
//        enterbutton.addTarget(self, action: #selector(MainViewController.enter), for: .touchUpInside)
//        cell.addSubview(enterbutton)
        return cell
    }
    
    
    @IBAction func createRoom(_ sender: Any) {
        let newRoomId: Int = roomData.count
        if newRoomId > 9{
            errorLabel.textColor = UIColor.red
            errorLabel.text = "ルームが多すぎます!"
        }else{
            roomRef.document("room\(newRoomId)").setData([
                "room" : newRoomId
            ]){ err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.tableview.reloadData()
                }
            }
        }
        
        
    }
    
    func enter(_ cell: TableViewCell){
        let indexPath: IndexPath = tableview.indexPath(for: cell)!
        roomId = indexPath.row
        performSegue(withIdentifier: "enter", sender: (Any).self)
    }
    @IBAction func backhome(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enter"{
            let viewController: ViewController = segue.destination as! ViewController
            viewController.username = username
            viewController.roomId = roomId
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
