//
//  EventProfileTableViewCell.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/26/23.
//

import UIKit

class EventProfileTableViewCell: UITableViewCell {
    static let identifier = "EventProfileTableViewCell"
    private let PostedBy: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Posted By: "
        label.numberOfLines = 0
        return label
        
    }()
    private let username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.sizeToFit()
        label.numberOfLines = 0
        return label
        
    }()
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        
        contentView.addSubview(PostedBy)
        contentView.addSubview(username)
        contentView.addSubview(photoImageView)
        backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = nil
        photoImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        PostedBy.frame = CGRect(x: 0, y: 0, width: frame.width/2, height: frame.height/2)
//          photoImageView.frame = CGRect(x: frame.width/2, y: 0, width: frame.width/4, height: frame.height/4)
//          username.frame = CGRect(x: 0, y: frame.height/4, width: frame.width, height: frame.height/4)
//          photoImageView.layer.cornerRadius = photoImageView.frame.width/2
        // Set the frame for the "Posted By" label
//          PostedBy.frame = CGRect(x: 16, y: 12, width: 100, height: 20)
//          // Set the frame for the photo image view
          let imageViewSize = frame.height/2 - 16
//          photoImageView.frame = CGRect(x: frame.width - imageViewSize - 24, y: 2, width: imageViewSize, height: imageViewSize)
//          photoImageView.layer.cornerRadius = imageViewSize/2
//          // Set the frame for the username label
//          username.frame = CGRect(x: 16, y: photoImageView.frame.height+2, width: frame.width - 32, height: 20)
//
//        NSLayoutConstraint.activate([
//                       username.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//                       username.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
//                       username.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
//                       username.widthAnchor.constraint(equalToConstant: frame.width/2),
//                       username.heightAnchor.constraint(equalToConstant: frame.height/2)
//                   ])
//        username.textAlignment = .right
//          username.textAlignment = .center

        NSLayoutConstraint.activate([
               PostedBy.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//               PostedBy.topAnchor.constraint(equalTo: contentView.topAnchor)
               PostedBy.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor)
           ])

        let profilePhotoSize = contentView.frame.height/2 - 12
           NSLayoutConstraint.activate([
               photoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
               photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
               photoImageView.widthAnchor.constraint(equalToConstant: profilePhotoSize ),
               photoImageView.heightAnchor.constraint(equalToConstant: profilePhotoSize )
           ])
           photoImageView.layer.cornerRadius = profilePhotoSize/2.0

        NSLayoutConstraint.activate([
            username.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            username.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            username.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            username.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        

    }
    public func configure(nm name: String, pho pfp:String)
    {
    
        let url = URL(string: pfp)
        photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "greyBox"))
        username.text = name

        
        
    }
}
