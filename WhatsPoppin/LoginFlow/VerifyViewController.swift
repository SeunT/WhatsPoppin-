//
//  VerifyViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/28/21.
//

import UIKit
import Firebase

class VerifyViewController: UIViewController {
    let db = Firestore.firestore()
    var User:User_info =  User_info()
    var Event:Events = Events()
    var Number:String!
    var verifyID:String!
    var test:Bool?
    private let code_label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My code is"
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        
        label.sizeToFit()
        return label
    }()
    private let continue_n :LoadingButton = {
        let button = LoadingButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = customColor.cgColor
        button.backgroundColor = customColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return button
    }()
    private let verify_n:UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.placeholder = "Phone Number"
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.keyboardType = .numberPad
        return textfield
    }()


    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(verify_n)
        view.addSubview(continue_n)
        view.addSubview(code_label)
        
       
        NSLayoutConstraint.activate([
            verify_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verify_n.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
            verify_n.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        NSLayoutConstraint.activate([
            continue_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continue_n.topAnchor.constraint(equalTo: verify_n.bottomAnchor, constant: 20),
            continue_n.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            continue_n.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            code_label.leftAnchor.constraint(equalTo: verify_n.leftAnchor),
            code_label.bottomAnchor.constraint(equalTo: verify_n.topAnchor,constant: -40)
        ])
        continue_n.addTarget(self, action: #selector(continue_b), for: .touchUpInside)

        
        // Do any additional setup after loading the view.
    }
    
    @objc private func continue_b()
    {

        continue_n.showLoading()
         let _ = verifyID
         let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: verify_n.text!)
        
          
        
        User.getOrCreateUser(cred: credentials)
         { return_num in
             if return_num == 1
             {
                 //need to create user
                 
//                 if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Nav1") as? UINavigationController {
//                     self.present(homeViewController, animated: true, completion: nil)
//                 }
                 self.continue_n.hideLoading()
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 let nav1 = storyboard.instantiateViewController(withIdentifier: "Nav1") as! UINavigationController
                 UIApplication.shared.keyWindow?.rootViewController = nav1
//                 self.view.window?.rootViewController = homeViewController
//                 self.view.window?.makeKeyAndVisible()
             }
             else if return_num == 2
             {
                 
                 //log in user
    
                 
                 if let user = Auth.auth().currentUser {
                     let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
                       let docRef = Firestore.firestore().collection("users").document(user.uid)
                       docRef.setData(["fcmToken": fcmToken], merge: true) { error in
                           if let error = error {
                               print("Error saving FCM token: \(error.localizedDescription)")
                           } else {
                               print("FCM token saved successfully")
                           }
                       }
                   }
                 
                 self.Event.loadUserEvents(){
                     res in
                     self.continue_n.hideLoading()
                    if res
                     {
                        DispatchQueue.main.async
                        {
//
//                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Nav3") as! UINavigationController
//                            //{
////                                self.navigationController?.popToRootViewController(animated: false)
//                                controller.modalPresentationStyle = .fullScreen
//                                self.present(controller, animated: true, completion: nil)
////                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let nav3 = storyboard.instantiateViewController(withIdentifier: "Nav3") as! UINavigationController
                            UIApplication.shared.keyWindow?.rootViewController = nav3
                            

                        }
                    }
                     else {
                         print("error logging in")
                         let alert = UIAlertController(title: "Error", message: "Error logging in. Please try again", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                         self.present(alert, animated: true)
                     }
           
                 }
              
                 
             }
             else
             {

              
//
                 let alert = UIAlertController(title: "Error", message: "Invalid code. Please try again", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
                     _ in
                     self.continue_n.hideLoading()
                 }))
                 self.present(alert, animated: true)
                 
             }
             
         }
    }
    
    
    @IBAction func verifyOtp(_ sender: Any)
    {
//       // guard let otpCode = otpOu.text! else {return}
//        let homeViewController = self.storyboard?.instantiateViewController(identifier: "Nav1") as? UINavigationController
//        let _ = verifyID
//        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: otpOu.text!)
//
//         continue_next.isEnabled = false
//         continue_next.isUserInteractionEnabled = false
//         continue_next.alpha = 0.5
//
//
//         present(self.loggingInAlert, animated: true, completion: nil)
//         activitySpinner.startAnimating()
//       User.getOrCreateUser(cred: credentials)
//        { return_num in
//            if return_num == 1
//            {
//                //need to create user
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
//            }
//            else if return_num == 2
//            {
//
//                //log in user
//
//                self.Event.loadUserEvents(){
//                    res in
//
//                   if res
//                    {
//                       DispatchQueue.main.async
//                       {
//                           self.activitySpinner.stopAnimating()
//                           self.activitySpinner.removeFromSuperview()
//                           self.loggingInAlert.dismiss(animated: true, completion: nil)
//                           let controller = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
//                           self.view.window?.rootViewController = controller
//                           self.view.window?.makeKeyAndVisible()
//                       }
//                   }
//                    else {
//                        print("error logging in")
//                    }
//
//                }
//
//
//            }
//            else
//            {
//
//                let alert = UIAlertController(title: "Error", message: "Invalid code. Please try again", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                self.present(alert, animated: true)
//
//            }
//
//        }
//
    }

}
