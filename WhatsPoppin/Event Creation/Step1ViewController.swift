//
//  Step1ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/17/22.
//

import UIKit

class Step1ViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var desc: UITextView!
    {
        didSet{
            desc.delegate = self
        
        }
    }
    
    private let question: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How would you describe your event?"
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
    
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Do any additional setup after loading the view.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
                if(segue.identifier == "1to2")
                {
                    if let destination: Step2ViewController = segue.destination as? Step2ViewController
                    {
                        
                       
                        destination.event_desc = self.desc.text!
                        
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
