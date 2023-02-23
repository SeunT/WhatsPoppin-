//
//  FollowButton.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/14/23.
//

import UIKit

final class FollowButton: UIButton {

    //        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.setTitle("Edit Profile", for: .normal)
    //        button.setTitleColor(customColor, for: .normal)
    //        button.layer.cornerRadius = 5
    //        button.layer.borderWidth = 0
    //        button.backgroundColor = .secondarySystemBackground
    //        button.layer.borderColor = button.backgroundColor?.cgColor
    
    enum State: String{
        case follow = "Follow"
        case unfollow = "Unfollow"
        
        var titleColor: UIColor {
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            switch self {
            case .follow: return .white
            case .unfollow: return customColor
//            case .unfollow: return .label
            }
        }
        var backgroundColor: UIColor {
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            switch self {
            case .follow: return customColor
            case .unfollow: return .secondarySystemBackground
            }
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(for state: State){
        setTitle(state.rawValue, for: .normal)
        backgroundColor = state.backgroundColor
        setTitleColor(state.titleColor, for: .normal)
        
        switch state {
        case .follow:
            layer.borderWidth = 0
        case .unfollow:
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            layer.borderWidth = 0
//            layer.borderWidth = 0.5
//            layer.borderColor = customColor.cgColor
        }
    }
}
