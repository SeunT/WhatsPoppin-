//
//  ProfileInfoHeaderCollectionReusableView.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/22/23.
//

import UIKit

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject
{
    func profileHeaderDidTapEditButton(_ header: ProfileInfoHeaderCollectionReusableView)
}
class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    var User:User_info =  User_info()
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    private let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let editProfileButton :UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(customColor, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = customColor.cgColor
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    private let name_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Medulla"
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.numberOfLines = 1
        return label
    }()
    private let bio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "Niche free yourself"
        label.textColor = .label
        label.numberOfLines = 0 //line wrap
        return label
    }()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
        addUserData()
    }
    private func addUserData()
    {
        let user = User.getUserData()
        name_label.text = user?.name!
        profileImageView.image = UIImage(data: (user?.pfp)!)
    
    }
    private func addSubviews() {
        addSubview(profileImageView)
        addSubview(editProfileButton)
        addSubview(name_label)
        addSubview(bio)
    }
    private func addButtonActions()
    {
        editProfileButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let profilePhotoSize = frame.width/4
        profileImageView.frame = CGRect(x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
        profileImageView.layer.cornerRadius = profilePhotoSize/2.0
        let buttonHeight = profilePhotoSize/2
        let buttonWidth = (frame.width-10-profilePhotoSize)/3
//        let yObject = profilePhoto.frame.origin.y + profilePhoto.frame.size.height
//        let xObject = profilePhoto.frame.origin.x + profilePhoto.frame.size.width
//
//        editProfileButton.frame = CGRect(x:xObject, y: 5+buttonHeight, width: buttonWidth*3, height: buttonHeight).integral
//        nameLabel.frame = CGRect(x:5, y: 5+yObject, width: frame.width-10, height: 50).integral
//        let yyObject = nameLabel.frame.origin.y + nameLabel.frame.size.width
        let biolabelSize = bio.sizeThatFits(frame.size)
//        bio.frame = CGRect(x:5, y: 5+yyObject, width: frame.width-10, height: biolabelSize.height).integral

        NSLayoutConstraint.activate([
            name_label.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
            name_label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10),
            name_label.widthAnchor.constraint(equalToConstant: frame.width-10),
            name_label.heightAnchor.constraint(equalToConstant: 50)
        ])

            NSLayoutConstraint.activate([
                bio.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
                bio.topAnchor.constraint(equalTo: name_label.bottomAnchor, constant: -5),
                bio.widthAnchor.constraint(equalToConstant: frame.width-10),
                bio.heightAnchor.constraint(equalToConstant: biolabelSize.height)
            ])

        NSLayoutConstraint.activate([
            editProfileButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                 editProfileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                 editProfileButton.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 30),
                 editProfileButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
    }
    
    //MARK - Actions
    @objc private func didTapEditButton()
    {
        delegate?.profileHeaderDidTapEditButton(self)
    }
    
}
