//
//  NameViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 7/23/21.
//

import UIKit

class NameViewController: UIViewController {
    
    private let continue_n :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(customColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return button
    }()
    private let name_n:UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.placeholder = "Phone Number"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.text = "My Name is..."
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(name_n)
        view.addSubview(continue_n)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            name_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name_n.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
            name_n.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: name_n.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: name_n.topAnchor, constant: -50),
        ])
        NSLayoutConstraint.activate([
            continue_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continue_n.topAnchor.constraint(equalTo: name_n.bottomAnchor, constant: 20),
            continue_n.widthAnchor.constraint(equalToConstant: 200)
        ])

        continue_n.addTarget(self, action: #selector(continue_next), for: .touchUpInside)

    }
    
    @objc private func continue_next()
    {
        if(name_n.text!.isEmpty)
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a Name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }
        else
        {
            let vc = SetupPictureViewController()
            vc.name = self.name_n.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }

}
