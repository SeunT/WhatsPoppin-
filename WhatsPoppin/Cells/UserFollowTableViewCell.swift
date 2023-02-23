//
//  UserFollowTableViewCell.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/13/23.
//

import UIKit
protocol UserFollowTableViewCellDelegate: AnyObject{
    func didTapFollowUnfollowButton(model: userRelationship)
}
enum FollowState {
    case following, not_following
    
}
struct userRelationship {
    let name: String
    let type: FollowState
}
class UserFollowTableViewCell: UITableViewCell {
    
    static let identifier = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    private var model: userRelationship?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    private let nameLabel:UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
//        label.text = "joe"
        return label
    }()
    private let followButton: UIButton = {
        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .link
        
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
//        contentView.addSubview(followButton)
        accessoryType = .disclosureIndicator
//        selectionStyle = .none
//        followButton.addTarget(self, action: #selector(didtapFollowButton), for: .touchUpInside)
        
    }
    @objc private func didtapFollowButton()
    {
        guard let model = model else {
            return
        }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    public func configure(with model: userRelationship)
//    {
//        self.model = model
//        nameLabel.text = model.name
//        switch model.type{
//        case .following:
//            //show unfollow button
//            followButton.setTitle("Unfollow", for: .normal)
//            followButton.setTitleColor(.label, for: .normal)
//            followButton.backgroundColor = .systemBackground
//            followButton.layer.borderWidth = 1
//            followButton.layer.borderColor = UIColor.label.cgColor
//        case .not_following:
//            //show follow button
//            followButton.setTitle("Follow", for: .normal)
//            followButton.setTitleColor(.white, for: .normal)
//            followButton.backgroundColor = .link
//            followButton.layer.borderWidth = 0
//        }
//
//    }
    func configure(with viewModel: ListUserTableViewCellViewModel) {
//        nameLabel.text = viewModel.username
        DatabaseManager.shared.findUsers(with: viewModel.uuid) { [weak self] username in

                DispatchQueue.main.async {
                    self?.nameLabel.text = username
                    self?.setNeedsLayout()
//                    self?.layoutIfNeeded()
            }
        }
               DatabaseManager.shared.profilePictureURL(for: viewModel.uuid) { [weak self] url in
                   DispatchQueue.main.async {
                       self?.profileImageView.sd_setImage(with: url, completed: nil)
            }
        }
    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
//        followButton.setTitle(nil, for: .normal)
//        followButton.layer.borderWidth = 0
//        followButton.backgroundColor = nil
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        NSLayoutConstraint.activate([
        //            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        //            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        //            profileImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height-6),
        //            profileImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height-6)
        //        ])
        //        profileImageView.layer.cornerRadius = profileImageView.frame.height/2.0
        //        let labelHeight = contentView.frame.height/2
        //        let buttonWidth = contentView.frame.width > 500 ? 220.0 : contentView.frame.width/3
        //        NSLayoutConstraint.activate([
        ////            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
        //            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        //            followButton.widthAnchor.constraint(equalToConstant: buttonWidth),
        //            followButton.heightAnchor.constraint(equalToConstant: contentView.frame.height-10)
        //
        //        ])
        //        NSLayoutConstraint.activate([
        //            nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 5),
        //            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
        //            nameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width-8-profileImageView.frame.width-buttonWidth),
        //            nameLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        //        ])
        nameLabel.sizeToFit()
        let size: CGFloat = contentView.frame.height/1.3
        profileImageView.frame = CGRect(x: 5, y: (contentView.frame.height-size)/2, width: size, height: size)
        profileImageView.layer.cornerRadius = size/2
        nameLabel.frame = CGRect(
            x: profileImageView.frame.maxX+10,
            y: 0,
            width: nameLabel.frame.width,
            height: contentView.frame.height)

    }
    
}
