//
//  LoginViewController.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
import UIKit
import Foundation

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {

        if(usernameTextField.text!.isEmpty){
            Helper.app.showAlert(title: "Hata", message: "kullanıcı adı alanı boş", vc: self)
         return
        }
        if(passwordTextField.text!.isEmpty){
          Helper.app.showAlert(title: "Hata", message: "Şifre alanı boş", vc: self)
          return
        }
        
        let session = URLSession.shared
        let url = api.login
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                var params :[String: Any]?
                params = ["username" : usernameTextField.text!, "password" : passwordTextField.text!]
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                    let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                        if let response = response {
                            let nsHTTPResponse = response as! HTTPURLResponse
                            let statusCode = nsHTTPResponse.statusCode
                            print ("status code = \(statusCode)")
                            if statusCode != 200{
                                DispatchQueue.main.async {
                               let alert = UIAlertController(title: "Hata", message: "kullanıcı adı veya şifre yanlış", preferredStyle: .alert)
                               alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in
                                 }))
                               self.present(alert, animated: true) {
                               self.presentingViewController?.dismiss(animated: true, completion: nil)
                               }
                                                                     }
                            }
                        }
                        if let error = error {
                            print ("\(error)")
                        }
                        if let data = data {
                             
                            do{
                                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                                    return
                                }
                                
                                let token = json["token"] as! String
                                
                                if token == "" {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Hata", message: "kullanıcı adı veya şifre yanlış", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: { _ in
                                          }))
                                        self.present(alert, animated: true) {
                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                        }
                                      }
                                } else {
                                    UserDefaults.standard.accessToken = token
                                    DispatchQueue.main.async {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let homeController = storyboard.instantiateViewController(withIdentifier: "home")
                                        if #available(iOS 13.0, *) {
                                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeController)
                                        } else {
                                            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(homeController)
                                        }
                                      }
                                }
                        
                                
                            }catch _ {
                                print ("OOps not good JSON formatted response")
                            }
                        }
                    })
                    task.resume()
                }catch _ {
                    print ("Oops something happened buddy")
                }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        makeTextFieldBorderstyle()
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func makeTextFieldBorderstyle(){
    if #available(iOS 13.0, *) {
        self.usernameTextField.borderStyle = .line
        self.passwordTextField.borderStyle = .line
      }
    }

    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
}


extension LoginViewController {
       
    func initializeHideKeyboard(){
    //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
    target: self,
    action: #selector(dismissMyKeyboard))
    //Add this tap gesture recognizer to the parent view
    view.addGestureRecognizer(tap)
       
    }
      
       
   
       
    @objc func dismissMyKeyboard(){
    //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
    //In short- Dismiss the active keyboard.
    view.endEditing(true)
    }
    
   }




