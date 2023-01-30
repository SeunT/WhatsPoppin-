//
//  ProfileTabsCollectionReusableView.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/22/23.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject
{
    func didTapGridButtonTab()
    func didTapListButtonTab()
}
class ProfileTabsCollectionReusableView: UICollectionReusableView
{
    static let identifier = "ProfileTabsCollectionReusableView"
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    struct Constants {
        static let padding: CGFloat = 8
    }
    private let gridButton:UIButton =
    {
        let button = UIButton()
        button.clipsToBounds = true
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.tintColor = customColor
        button.setBackgroundImage(UIImage(systemName: "square.grid.3x3"), for: .normal)
        return button
    }()
    private let listButton:UIButton =
    {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    override init(frame:CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(gridButton)
        addSubview(listButton)
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(didTapListButton), for: .touchUpInside)
    }
    @objc private func didTapGridButton()
    {
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        gridButton.tintColor = customColor
        listButton.tintColor = .lightGray
        delegate?.didTapGridButtonTab()
        
    }
    @objc private func didTapListButton()
    {
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        gridButton.tintColor = .lightGray
        listButton.tintColor = customColor
        delegate?.didTapListButtonTab()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = frame.height - (Constants.padding * 2)
        let gridButtonX = ((frame.width/2)-size)/2
        gridButton.frame = CGRect(x: gridButtonX, y: Constants.padding, width: size, height: size)
        listButton.frame = CGRect(x: gridButtonX+(frame.width/2), y: Constants.padding, width: size, height: size)
        
        
        
        
    }
}
