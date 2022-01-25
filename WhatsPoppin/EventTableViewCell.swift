//
//  EventTableViewCell.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventdis: UILabel!
    
    @IBOutlet weak var eventimage: UIImageView!{
        didSet {
         eventimage.layer.cornerRadius = eventimage.bounds.width / 2
         eventimage.clipsToBounds = true
         }
     }
    
    @IBOutlet weak var eventTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
