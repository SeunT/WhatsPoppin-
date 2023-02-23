//
//  ProfileInfoHeaderCollectionReusableView.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/22/23.
//

import UIKit
import SDWebImage
import CoreData

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject
{
//    func profileHeaderDidTapEditButton(_ header: ProfileInfoHeaderCollectionReusableView)
//    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
//    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowers(_ containerView: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollowing(_ containerView: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapEditProfile(_ containerView: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapFollow(_ containerView: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapUnFollow(_ containerView: ProfileInfoHeaderCollectionReusableView)
    func profileHeaderDidTapShare(_ containerView: ProfileInfoHeaderCollectionReusableView)
}

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    private var action = ProfileButtonType.edit
    
    var User:User_info =  User_info()
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    private let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        imageView.layer.masksToBounds = true
        return imageView
    }()
//    private let editProfileButton :UIButton = {
//        let button = UIButton()
//        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Edit Profile", for: .normal)
//        button.setTitleColor(customColor, for: .normal)
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 0
//        button.backgroundColor = .secondarySystemBackground
//        button.layer.borderColor = button.backgroundColor?.cgColor
//        return button
//    }()
        private let shareButton :UIButton = {
            let button = UIButton()
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Share Profile", for: .normal)
            button.setTitleColor(customColor, for: .normal)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0
            button.backgroundColor = .secondarySystemBackground
            button.layer.borderColor = button.backgroundColor?.cgColor
            return button
        }()
    private let name_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Medulla"
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.numberOfLines = 1
        return label
    }()
    private let bio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "                   "
        label.textColor = .label
        label.numberOfLines = 0 //line wrap
        return label
    }()
//    private let followingButton:UIButton = {
//        let button = UIButton()
//        button.setTitleColor(.label, for: .normal)
//        button.setTitle("Following", for: .normal)
//        //        button.backgroundColor = .secondarySystemBackground
//        button.translatesAutoresizingMaskIntoConstraints = false
//        // Adjust the font size to fit the width of the button
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
////        button.titleLabel?.minimumScaleFactor = 0.8
//        return button
//    }()
//    private let followersButton:UIButton = {
//        let button = UIButton()
//        button.setTitleColor(.label, for: .normal)
//        button.setTitle("Followers", for: .normal)
//        //        button.backgroundColor = .secondarySystemBackground
//        button.translatesAutoresizingMaskIntoConstraints = false
//        // Adjust the font size to fit the width of the button
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
////        button.titleLabel?.minimumScaleFactor = 0.6
//        return button
//    }()
    private let followerCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.setTitle("0", for: .normal)
        button.titleLabel?.textAlignment = .center
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()

    private let followingCountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 2
        button.setTitle("0", for: .normal)
        button.titleLabel?.textAlignment = .center
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        return button
    }()
    private let actionButton = FollowButton()
    private var isFollowing = false
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
    }
    public func configure(with viewModel: ProfileHeaderViewModel) {
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl, placeholderImage: UIImage(named: "greyBox"))
        var text = ""
//        if let name = viewModel.name {
//            text = name + "\n"
//        }
        name_label.text = viewModel.name
        text += viewModel.bio ?? "Whats Poppin"
        bio.text = text

        followerCountButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingCountButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)

        self.action = viewModel.buttonType

        switch viewModel.buttonType {
        case .edit:
//            actionButton.backgroundColor = .systemBackground
//            actionButton.setTitle("Edit Profile", for: .normal)
//            actionButton.setTitleColor(.label, for: .normal)
//            actionButton.layer.borderWidth = 0.5
//            actionButton.layer.borderColor = UIColor.tertiaryLabel.cgColor
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.setTitle("Edit Profile", for: .normal)
            actionButton.setTitleColor(customColor, for: .normal)
            actionButton.layer.cornerRadius = 5
            actionButton.layer.borderWidth = 0
            actionButton.backgroundColor = .secondarySystemBackground
//            actionButton.layer.borderColor = actionButton.backgroundColor?.cgColor
        
        case .follow(let isFollowing):
            self.isFollowing = isFollowing
            actionButton.configure(for: isFollowing ? .unfollow : .follow)
        }
        
    }
    
    public func addUserData()
    {
//        let user = User.getUserData()
//        name_label.text = user?.name!
//        bio.text = user?.bio ?? ""
        
//        print(user?.bio!)
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
            
            context.perform {
                
                do {
                    let users = try context.fetch(fetchRequest) as! [Core_user]
                    
                    DispatchQueue.main.async {
                        
                        
                        self.name_label.text = users.first?.name!
                        self.bio.text = users.first?.bio ?? ""
                        if let urlpfp = URL(string: (users.first?.pfp!)!) {
                            // Use the urlpfp variable
                            print(urlpfp)
                            self.profileImageView.sd_setImage(with: urlpfp, placeholderImage: UIImage(named: "greyBox"))
                        } else {
                            print("Error creating URL")
                        }
                        
                    }
                }
                catch
                {
                    print("Error grabbing user info from core data in profile info header \(error)")
                    
                    
                }
                
            }

    
    }
    
    public func addOtherUserDara(id UserID:String, completion:@escaping(Bool)->())
    {
        User.getOtherUser(uid: UserID) {
            res in
            let url = URL(string: res.pfp!)
            self.name_label.text = res.username!
            self.bio.text = res.bio!
            self.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "greyBox"))
            completion(true)

        }
    }
    private func addSubviews() {
        addSubview(profileImageView)
//        addSubview(editProfileButton)
        addSubview(name_label)
        addSubview(bio)
//        addSubview(followingButton)
//        addSubview(followersButton)
        addSubview(followerCountButton)
        addSubview(followingCountButton)
        addSubview(actionButton)
        addSubview(shareButton)
    }
    private func addButtonActions()
    {
//        editProfileButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
//        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
//        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        followerCountButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
        followingCountButton.addTarget(self, action: #selector(didTapFollowing), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let profilePhotoSize = frame.width/2
//        profileImageView.frame = CGRect(x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            profileImageView.widthAnchor.constraint(equalToConstant: profilePhotoSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profilePhotoSize)
            
        ])
        profileImageView.layer.cornerRadius = profilePhotoSize/2.0
        let buttonHeight = profilePhotoSize/4
        let buttonWidth = (frame.width-10-profilePhotoSize)/2.75

//        let yObject = profilePhoto.frame.origin.y + profilePhoto.frame.size.height
//        let xObject = profilePhoto.frame.origin.x + profilePhoto.frame.size.width
//
//        editProfileButton.frame = CGRect(x:xObject, y: 5+buttonHeight, width: buttonWidth*3, height: buttonHeight).integral
//        nameLabel.frame = CGRect(x:5, y: 5+yObject, width: frame.width-10, height: 50).integral
//        let yyObject = nameLabel.frame.origin.y + nameLabel.frame.size.width
        let biolabelSize = bio.sizeThatFits(frame.size)
//        bio.frame = CGRect(x:5, y: 5+yyObject, width: frame.width-10, height: biolabelSize.height).integral

//        NSLayoutConstraint.activate([
//            name_label.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
//            name_label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10),
//            name_label.widthAnchor.constraint(equalToConstant: frame.width-10),
//            name_label.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
        NSLayoutConstraint.activate([
            name_label.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            name_label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10),
            name_label.widthAnchor.constraint(equalToConstant: frame.width-10),
            name_label.heightAnchor.constraint(equalToConstant: 50)
        ])

//            NSLayoutConstraint.activate([
//                bio.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
//                bio.topAnchor.constraint(equalTo: name_label.bottomAnchor, constant: -5),
//                bio.widthAnchor.constraint(equalToConstant: frame.width-10),
//                bio.heightAnchor.constraint(equalToConstant: biolabelSize.height)
//            ])
        NSLayoutConstraint.activate([
            bio.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            bio.topAnchor.constraint(equalTo: name_label.bottomAnchor, constant: -5),
            bio.widthAnchor.constraint(equalToConstant: frame.width-10),
            bio.heightAnchor.constraint(equalToConstant: biolabelSize.height)
        ])

//        NSLayoutConstraint.activate([
//            editProfileButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
//                 editProfileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
//                 editProfileButton.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 40),
//                 editProfileButton.heightAnchor.constraint(equalToConstant: buttonHeight)
//            ])
//        NSLayoutConstraint.activate([
//            followingButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
//            followingButton.topAnchor.constraint(equalTo: topAnchor,constant: 5),
//            followingButton.widthAnchor.constraint(equalToConstant: buttonWidth),
//            followingButton.heightAnchor.constraint(equalToConstant: buttonHeight)
//        ])
//
//        NSLayoutConstraint.activate([
//            followersButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
//            followersButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
//            followersButton.widthAnchor.constraint(equalToConstant: buttonWidth),
//            followersButton.heightAnchor.constraint(equalToConstant: buttonHeight)
//        ])
//
//        let fontSize = min(followingButton.titleLabel?.font.pointSize ?? 0, followersButton.titleLabel?.font.pointSize ?? 0)
//        followingButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
//        followersButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
//            actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            actionButton.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 40),
            actionButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
//            actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            shareButton.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 40),
            shareButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            shareButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45)
        ])
        NSLayoutConstraint.activate([
            followingCountButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            followingCountButton.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            followingCountButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            followingCountButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        NSLayoutConstraint.activate([
            followerCountButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            followerCountButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            followerCountButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            followerCountButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])

        let fontSize = min(followingCountButton.titleLabel?.font.pointSize ?? 0, followerCountButton.titleLabel?.font.pointSize ?? 0)
        followingCountButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        followerCountButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
 
    }
    
//    public func disableEdit()
//    {
//        editProfileButton.isHidden = true
//        editProfileButton.isUserInteractionEnabled = false
//        editProfileButton.isEnabled = false
//    }
    
    
    //MARK - Actions
//    @objc private func didTapEditButton()
//    {
//        delegate?.profileHeaderDidTapEditButton(self)
//    }
//    @objc private func didTapFollowingButton()
//    {
//        delegate?.profileHeaderDidTapFollowingButton(self)
//    }
//    @objc private func didTapFollowersButton()
//    {
//        delegate?.profileHeaderDidTapFollowersButton(self)
//    }
    @objc func didTapShare() {
        delegate?.profileHeaderDidTapShare(self)
    }
    @objc func didTapFollowers() {
        delegate?.profileHeaderDidTapFollowers(self)
    }

    @objc func didTapFollowing() {
        delegate?.profileHeaderDidTapFollowing(self)
    }
    @objc func didTapActionButton() {
        switch action {
        case.edit:
            delegate?.profileHeaderDidTapEditProfile(self)
        case .follow:
            if self.isFollowing {
                // unfollow
                delegate?.profileHeaderDidTapUnFollow(self)
            }
            else {
                // Follow
                delegate?.profileHeaderDidTapFollow(self)
            }
            self.isFollowing = !isFollowing
            actionButton.configure(for: isFollowing ? .unfollow : .follow)
        }
    }
    
    
}
