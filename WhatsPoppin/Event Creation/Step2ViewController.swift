//
//  Step2ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/17/22.
//

import UIKit
import CoreLocation

class Step2ViewController: UIViewController, Step4ViewControllerDelegate {
    func step4viewcontroller(_ vc: Step4ViewController, description perm_desc: String?, date_e perm_date: Date) {
        let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           dateFormatter.timeStyle = .short
        self.event_desc = perm_desc
        self.output.text = dateFormatter.string(from: perm_date)
        self.Time.setDate(perm_date, animated: true)
    }
//    var event_date:Date!
    var event_desc:String!
    var pin : CLLocationCoordinate2D?
    var address:String!
    private let continue_n :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(customColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
        return button
    }()
    private let output: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "When will your event be?"
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
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
    
    private let Time: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.preferredDatePickerStyle = .wheels
        return date
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(output)
        view.addSubview(question)
        view.addSubview(continue_n)
        view.addSubview(Time)
        datePickerValueChanged()
        NSLayoutConstraint.activate([
            output.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            output.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.3),
            output.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            output.bottomAnchor.constraint(equalTo: continue_n.topAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            question.leadingAnchor.constraint(equalTo: output.leadingAnchor),
            question.topAnchor.constraint(equalTo: output.topAnchor, constant: -50),
        ])
        NSLayoutConstraint.activate([
            continue_n.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continue_n.topAnchor.constraint(equalTo: output.bottomAnchor, constant: 50),
            continue_n.widthAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            Time.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Time.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            Time.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        continue_n.addTarget(self, action: #selector(continue_next), for: .touchUpInside)
        Time.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
//        var dateFormatter = DateFormatter()
//
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        dateFormatter.timeStyle = DateFormatter.Style.short

        //display.text = dateFormatter.string(from: timing.date)
//        continue_next.titleLabel?.adjustsFontSizeToFitWidth = true;
//        continue_next.titleLabel?.minimumScaleFactor = 0.5;
        // Do any additional setup after loading the view.
    }
    @objc private func continue_next()
    {
//        self.performSegue(withIdentifier: "2to4", sender: nil)

        let  destination = Step4ViewController()

        print(Time.date)
        destination.event_addy = address
        destination.location = pin
        destination.event_desc = event_desc
        destination.event_date = Time.date
        destination.delegate = self
        self.navigationController?.pushViewController(destination, animated: true)
        
//        performSegue(withIdentifier: "2to3", sender: self)
        
                
        
    }
    
    @objc private func datePickerValueChanged()
    {
        let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           dateFormatter.timeStyle = .short
           output.text = dateFormatter.string(from: Time.date)
    }
    
//    @IBAction func display_time(_ sender: Any)
//    {
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        dateFormatter.timeStyle = DateFormatter.Style.short
//
//        display.text = dateFormatter.string(from: timing.date)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//
//                if(segue.identifier == "2to3")
//                {
//                    if let destination: Step3ViewController = segue.destination as? Step3ViewController
//                    {
//
//                        destination.event_desc = self.event_desc
//                        destination.event_date = self.Time.date
//
//
//                    }
//                }
//
//    }

    
}
