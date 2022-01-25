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
    var Number:String!
    var verifyID:String!
    var test:Bool?
    @IBOutlet weak var otpOu: UITextField!
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func verifyOtp(_ sender: Any)
    {
       // guard let otpCode = otpOu.text! else {return}
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "Nav1") as? UINavigationController
        let _ = verifyID
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: otpOu.text!)
        
        Auth.auth().signIn(with: credentials)
        { (results, error) in
              if  error == nil
                {
                    
                    
                    
                    print(results!.user.uid)
                    self.userDefault.setValue((results?.user.uid), forKey: "UserID")
                    self.userDefault.synchronize()
                    
                    self.db.collection("Users").document(results!.user.uid).getDocument { (doc, erro) in
                        if erro == nil
                            {
                          
                            
                                if !(doc!.exists)
                                    { //account not created yet
                                        self.view.window?.rootViewController = homeViewController
                                        self.view.window?.makeKeyAndVisible()
                                    }
                                else if (doc!.exists)
                                    { //account is already created
                                    let controller = self.storyboard?.instantiateViewController(identifier: "Nav2") as? UINavigationController
                                    self.view.window?.rootViewController = controller
                                    self.view.window?.makeKeyAndVisible()
                                    }
                                
                            }
                       
                    }
                }
            else
              {
                
                let alert = UIAlertController(title: "Error", message: "Invalid code. Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
                //error verifying phone number
              }
            
        }
    }
        
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
