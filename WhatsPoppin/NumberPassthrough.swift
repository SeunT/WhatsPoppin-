//
//  NumberPassthrough.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/28/21.
//

import UIKit
import Firebase
class NumberPassthrough: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var Phone: UITextField!
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func Signin(_ sender: Any) {
        
        let verifycontroller = self.storyboard?.instantiateViewController(identifier: "Verify") as? VerifyViewController
        PhoneAuthProvider.provider().verifyPhoneNumber(self.Phone.text!, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                
                print(verificationID!)
                guard let verifyID = verificationID else {return}
                self.userDefault.setValue(verifyID, forKey: "verificationID")
                self.userDefault.synchronize()
                
                verifycontroller?.verifyID = self.userDefault.string(forKey: "verificationID")
                self.view.window?.rootViewController = verifycontroller
                self.view.window?.makeKeyAndVisible()
            }
            else
            {
                print("Unable to get verification code from firebase", error?.localizedDescription ?? String.self)
            }
        }
        
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        DispatchQueue.main.async {
            PhoneAuthProvider.provider().verifyPhoneNumber(self.Phone.text!, uiDelegate: nil) { (verificationID, error) in
         
            if error == nil {
                
                print(verificationID)
                guard let verifyID = verificationID else {return}
                self.userDefault.setValue(verifyID, forKey: "verificationID")
                self.userDefault.synchronize()
               
                if(segue.identifier == "Pass2Verify")
                {
                    if let destination: VerifyViewController = segue.destination as? VerifyViewController
                    {
                        
                       
                        destination.verifyID = self.userDefault.string(forKey: "verificationID")
                        
                    }
                }
                
              
            }
            else
            {
                print("Unable to get verification code from firebase", error?.localizedDescription)
            }
            }
        }
           
    }*/
        
       
       
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
