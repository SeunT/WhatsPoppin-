//
//  Step2ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/17/22.
//

import UIKit

class Step2ViewController: UIViewController {
 
    var event_desc:String!
    
    @IBOutlet weak var timing: UIDatePicker!
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var continue_next: UIButton!
  
    override func viewDidLoad() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short

        display.text = dateFormatter.string(from: timing.date)
        
        super.viewDidLoad()
        continue_next.titleLabel?.adjustsFontSizeToFitWidth = true;
        continue_next.titleLabel?.minimumScaleFactor = 0.5;
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func display_time(_ sender: Any)
    {
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short

        display.text = dateFormatter.string(from: timing.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
                if(segue.identifier == "2to3")
                {
                    if let destination: Step3ViewController = segue.destination as? Step3ViewController
                    {
                        
                        destination.event_desc = self.event_desc
                        destination.event_date = self.timing.date
                        
                        
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
