//
//  HomeViewController.swift
//  chatroom
//
//  Created by 斧田洋人 on 2018/03/28.
//  Copyright © 2018年 斧田洋人. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITextFieldDelegate {
    
    var db: Firestore!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        if loginTextField.text != ""{
            performSegue(withIdentifier: "login", sender: (Any).self)
        }else{
            errorLabel.textColor = UIColor.red
            errorLabel.text = "ニックネームを入力してください"
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login"{
            let viewController:MainViewController = segue.destination as! MainViewController
            viewController.username = self.loginTextField.text!
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
