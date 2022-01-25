//
//  NameViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 7/23/21.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var Name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
                if(segue.identifier == "Name2Setup")
                {
                    if let destination: SetupPictureViewController = segue.destination as? SetupPictureViewController
                    {
                        
                       
                        destination.name = self.Name.text!
                        
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
