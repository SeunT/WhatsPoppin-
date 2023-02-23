//
//  ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/19/21.
//

import UIKit

class ViewController: UIViewController {

    private let textView: UITextView = {
        let textview = UITextView()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        textview.textAlignment = .center
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.text = "By Creating an Account or Signing in, you agree to our Terms. Learn how we process your data in our Privacy Policy."
        textview.isEditable = false
        textview.isSelectable = true
        textview.font = UIFont(name: "Helvetica Neue", size: 12)
        textview.dataDetectorTypes = .link
        textview.textContainerInset = .zero
        textview.textContainer.lineFragmentPadding = 0
        // Create attributed string for terms link
        let termsRange = (textview.text as NSString).range(of: "Terms")
        let attributedString = NSMutableAttributedString(string: textview.text)
        attributedString.addAttribute(.link, value: "https://www.medullalogic.com/whatspoppin-terms-of-service", range: termsRange)
        // Create attributed string for privacy policy link
        let policyRange = (textview.text as NSString).range(of: "Privacy Policy")
        attributedString.addAttribute(.link, value: "https://www.medullalogic.com/whatspoppin-privacy", range: policyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: policyRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: policyRange)
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedString.length))
        textview.attributedText = attributedString
        textview.sizeToFit()
        textview.textColor = .white
        textview.linkTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white]
        textview.backgroundColor = customColor
        return textview
    }()
    
    private let appicon: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cup")
        return imageView
    }()
    private let appname: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "WhatsPoppin"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        label.sizeToFit()
        return label
    }()
    private let signinB :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SIGN IN WITH PHONE NUMBER", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        button.backgroundColor = customColor
        return button
    }()
    private let skip :UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "skip")
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedText.length))
        button.setAttributedTitle(attributedText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
        return button
    }()
    
    override func viewDidLoad() {

//        rgba(39,2,81,255)
            super.viewDidLoad()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        view.backgroundColor = customColor
        signinB.addTarget(self, action: #selector(continue_next), for: .touchUpInside)
        skip.addTarget(self, action: #selector(skip_view), for: .touchUpInside)
        // Do any additional setup after loading the view.
        view.addSubview(appicon)
        view.addSubview(signinB)
        view.addSubview(appname)
        view.addSubview(textView)
        view.addSubview(skip)
    
//        appicon.frame = CGRect(x: view.frame.minX, y: view.frame.midY, width: 125, height: 125).integral
        NSLayoutConstraint.activate([
//            appicon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            appicon.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            appicon.heightAnchor.constraint(equalToConstant: 50),
            appicon.widthAnchor.constraint(equalToConstant: 50),
            appicon.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -100),
            appicon.rightAnchor.constraint(equalTo: appname.leftAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            appname.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            appname.leftAnchor.constraint(equalTo: appicon.rightAnchor, constant: 0),
            appname.centerYAnchor.constraint(equalTo: appicon.centerYAnchor)
            
        ])

        NSLayoutConstraint.activate([
            signinB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            signinB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            signinB.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signinB.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: signinB.topAnchor, constant: -70),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.leftAnchor.constraint(equalTo: signinB.leftAnchor, constant: 25),
            textView.rightAnchor.constraint(equalTo: signinB.rightAnchor, constant: -25),
            textView.heightAnchor.constraint(equalToConstant: 50),
            textView.widthAnchor.constraint(equalToConstant: 0)
        ])
        
        NSLayoutConstraint.activate([
            skip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skip.topAnchor.constraint(equalTo: signinB.bottomAnchor),
            skip.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
     
    }

    override func viewDidAppear(_ animated: Bool)
    {
        //update boolean to true so the map spawns on the users current location
        //this is used if a user does not exit out of the map completely and decides to login
        UserDefaults.standard.set(true, forKey: "updateMap")
        
    }
    @objc func skip_view()
    {
        let vc = MapViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func continue_next()
    {
        let vc = NumberPassthrough()
//        vc.title =
        navigationController?.pushViewController(vc, animated: true)

    }
 
}

