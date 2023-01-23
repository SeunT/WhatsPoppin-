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

        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
   
    @IBAction func Signin(_ sender: Any) {
        
        let verifycontroller = self.storyboard?.instantiateViewController(identifier: "Verify") as? VerifyViewController
        //self.Phone.text!
        if(Phone.text!.isEmpty)
        {
            let alert = UIAlertController(title: "Error", message: "Please enter in a valid phone number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
        var number = Phone.text!.replacingOccurrences(of: "-", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        number = number.replacingOccurrences(of: "(", with: "")
        let phoneNumber = "+1\(number.replacingOccurrences(of: ")", with: ""))"
//        let phoneNumber = "+14807438510"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
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
                let alert = UIAlertController(title: "Error", message: "Please enter in a valid phone number", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
                print("Unable to get verification code from firebase", error?.localizedDescription ?? String.self)
            }
        }
        }
        
    }


}
