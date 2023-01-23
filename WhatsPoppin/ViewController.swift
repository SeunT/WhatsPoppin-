//
//  ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/19/21.
//

import UIKit

class ViewController: UIViewController {

    
    private let signinB :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SIGN IN WITH PHONE NUMBER", for: .normal)
        button.setTitleColor(customColor, for: .normal)
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 1
//        button.layer.borderColor = customColor.cgColor
//        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    override func viewDidLoad() {

        
            super.viewDidLoad()
        view.backgroundColor = .systemBackground
        signinB.addTarget(self, action: #selector(continue_next), for: .touchUpInside)
        // Do any additional setup after loading the view.
        view.addSubview(signinB)
        NSLayoutConstraint.activate([
            signinB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            signinB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            signinB.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signinB.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    

    @objc func continue_next()
    {
        let vc = NumberPassthrough()
//        vc.title =
        navigationController?.pushViewController(vc, animated: true)

    }
 
}

