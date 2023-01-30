//
//  Step1ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/17/22.
//

import UIKit
import CoreLocation

class Step1ViewController: UIViewController, UITextViewDelegate{

    var location : CLLocationCoordinate2D?
    var event_addy:String!
    
    private let continue_n :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(customColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return button
    }()
    private let question_text:UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
//        textfield.placeholder = "Phone Number"
        textview.backgroundColor = .systemGray6
        textview.font = UIFont(name: "HelveticaNeue", size: 14)
        textview.isScrollEnabled = false
        return textview
    }()
    private let question: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How would you describe your event?"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()

    override func viewDidLoad() {
    
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(question)
        view.addSubview(question_text)
        view.addSubview(continue_n)
        NSLayoutConstraint.activate([
            question_text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            question_text.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
            question_text.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            question_text.bottomAnchor.constraint(equalTo: continue_n.topAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            question.leadingAnchor.constraint(equalTo: question_text.leadingAnchor),
            question.topAnchor.constraint(equalTo: question_text.topAnchor, constant: -50),
        ])
        NSLayoutConstraint.activate([
            continue_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continue_n.topAnchor.constraint(equalTo: question_text.bottomAnchor, constant: 20),
            continue_n.widthAnchor.constraint(equalToConstant: 200)
        ])

        question_text.delegate = self
        continue_n.addTarget(self, action: #selector(continue_next), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc private func continue_next()
    {
        if(question_text.text!.isEmpty)
        {
            let alert = UIAlertController(title: "Add a Description", message: "Please enter a Description", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)

        }
        else
        {
            let vc = Step2ViewController()
            vc.event_desc = question_text.text!
            vc.address = event_addy
            vc.pin = location
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }

    
    func textViewDidChange(_ textView: UITextView) {
          let fixedWidth = textView.frame.size.width
          textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          var newFrame = textView.frame
          newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
          textView.frame = newFrame
    }

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        return self.textLimit(existingText: textView.text,
                              newText: text,
                              limit: 100)
    }

    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {

        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }

    
}
