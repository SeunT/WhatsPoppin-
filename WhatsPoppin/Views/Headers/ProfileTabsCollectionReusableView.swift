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
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
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
        gridButton.tintColor = .systemBlue
        listButton.tintColor = .lightGray
        delegate?.didTapGridButtonTab()
        
    }
    @objc private func didTapListButton()
    {
        gridButton.tintColor = .lightGray
        listButton.tintColor = .systemBlue
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
