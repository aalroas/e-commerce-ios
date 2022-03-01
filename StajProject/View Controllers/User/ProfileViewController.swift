//
//  ProfileViewController.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func Logout(_ sender: Any) {
        UserDefaults.standard.accessToken = ""
        let login = _Storyboard.main.instantiateViewController(withIdentifier: "login") as! LoginViewController
    }
    
}

