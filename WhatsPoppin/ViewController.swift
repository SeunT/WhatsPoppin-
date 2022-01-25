//
//  ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 5/19/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signin: UIButton!
    
    override func viewDidLoad() {
        signin.center = view.center
        signin.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setAppropriateFontSize( butt:UIButton){
        let maxFontSize = butt.frame.height
        butt.titleLabel!.font = UIFont(name: "Helvetica", size: maxFontSize)
        butt.titleLabel!.adjustsFontSizeToFitWidth = true
        butt.titleLabel!.minimumScaleFactor = 0.01
    }
}

