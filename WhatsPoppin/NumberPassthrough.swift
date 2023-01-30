//
//  NumberPassthrough.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/28/21.
//

import UIKit
import Firebase
class NumberPassthrough: UIViewController {


    private let continue_n :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = customColor.cgColor
        button.backgroundColor = customColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return button
    }()
    private let phone_n:UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.placeholder = "Phone Number"
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .phonePad
        return textfield
    }()

    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(phone_n)
        view.addSubview(continue_n)
        
        NSLayoutConstraint.activate([
            phone_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phone_n.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
            phone_n.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        NSLayoutConstraint.activate([
            continue_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continue_n.topAnchor.constraint(equalTo: phone_n.bottomAnchor, constant: 20),
            continue_n.widthAnchor.constraint(equalToConstant: 200),
            continue_n.heightAnchor.constraint(equalToConstant: 50)
        ])

        continue_n.addTarget(self, action: #selector(continue_next), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
   
    @IBAction func Signin(_ sender: Any) {
        
//        let verifycontroller = self.storyboard?.instantiateViewController(identifier: "Verify") as? VerifyViewController
//        //self.Phone.text!
//        if(Phone.text!.isEmpty)
//        {
//            let alert = UIAlertController(title: "Error", message: "Please enter in a valid phone number", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//        }
//        else
//        {
//        var number = Phone.text!.replacingOccurrences(of: "-", with: "")
//        number = number.replacingOccurrences(of: " ", with: "")
//        number = number.replacingOccurrences(of: "(", with: "")
//        let phoneNumber = "+1\(number.replacingOccurrences(of: ")", with: ""))"
////        let phoneNumber = "+14807438510"
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
//            if error == nil {
//
//                print(verificationID!)
//                guard let verifyID = verificationID else {return}
//                self.userDefault.setValue(verifyID, forKey: "verificationID")
//                self.userDefault.synchronize()
//
//                verifycontroller?.verifyID = self.userDefault.string(forKey: "verificationID")
//                self.view.window?.rootViewController = verifycontroller
//                self.view.window?.makeKeyAndVisible()
//
//            }
//            else
//            {
//                let alert = UIAlertController(title: "Error", message: "Please enter in a valid phone number", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                self.present(alert, animated: true)
//
//                print("Unable to get verification code from firebase", error?.localizedDescription ?? String.self)
//            }
//        }
//        }
//
    }
    @objc private func continue_next()
    {
        let vc = VerifyViewController()
//        let verifycontroller = self.storyboard?.instantiateViewController(identifier: "Verify") as? VerifyViewController
        //self.Phone.text!
        if(phone_n.text!.isEmpty)
        {
            let alert = UIAlertController(title: "Error", message: "Please enter in a valid phone number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
        var number = phone_n.text!.replacingOccurrences(of: "-", with: "")
        number = number.replacingOccurrences(of: " ", with: "")
        number = number.replacingOccurrences(of: "(", with: "")
        let phoneNumber = "+1\(number.replacingOccurrences(of: ")", with: ""))"
//        let phoneNumber = "+14807438510"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                
                print(verificationID!)
                guard let verifyID = verificationID else {return}
//                self.userDefault.setValue(verifyID, forKey: "verificationID")
//                self.userDefault.synchronize()
                    vc.verifyID = verifyID
//                verifycontroller?.verifyID = self.userDefault.string(forKey: "verificationID")
//                self.view.window?.rootViewController = verifycontroller
//                self.view.window?.makeKeyAndVisible()
                self.navigationController?.pushViewController(vc, animated: true)
  
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
