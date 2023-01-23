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

    @IBOutlet weak var continue_next: UIButton!
    let activitySpinner: UIActivityIndicatorView = {
            let activitySpinner = UIActivityIndicatorView(style: .medium)
            activitySpinner.translatesAutoresizingMaskIntoConstraints = false
            activitySpinner.hidesWhenStopped = true
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            activitySpinner.color = customColor
            return activitySpinner
        }()
    let loggingInAlert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)

    @IBOutlet weak var otpOu: UITextField!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        loggingInAlert.view.addSubview(activitySpinner)
        NSLayoutConstraint.activate([
            activitySpinner.centerXAnchor.constraint(equalTo: loggingInAlert.view.centerXAnchor),
            activitySpinner.centerYAnchor.constraint(equalTo: loggingInAlert.view.centerYAnchor)
        ])
        

        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func verifyOtp(_ sender: Any)
    {
       // guard let otpCode = otpOu.text! else {return}
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "Nav1") as? UINavigationController
        let _ = verifyID
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: otpOu.text!)
        
         continue_next.isEnabled = false
         continue_next.isUserInteractionEnabled = false
         continue_next.alpha = 0.5
         
         
         present(self.loggingInAlert, animated: true, completion: nil)
         activitySpinner.startAnimating()
       User.getOrCreateUser(cred: credentials)
        { return_num in
            if return_num == 1
            {
                //need to create user
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
            else if return_num == 2
            {
                
                //log in user
   
                self.Event.loadUserEvents(){
                    res in
                    
                   
                    DispatchQueue.main.async
                    {
                        self.activitySpinner.stopAnimating()
                        self.activitySpinner.removeFromSuperview()
                        self.loggingInAlert.dismiss(animated: true, completion: nil)
                        let controller = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
                        self.view.window?.rootViewController = controller
                        self.view.window?.makeKeyAndVisible()
                       }
                  
                }
             
                
            }
            else
            {

                let alert = UIAlertController(title: "Error", message: "Invalid code. Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            }
            
        }
      
    }

}
