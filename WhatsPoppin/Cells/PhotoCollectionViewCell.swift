//
//  PhotoCollectionViewCell.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/22/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell
{
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
//        accessibilityLabel = "User post image"
//        accessibilityHint = "Double-tap to open post"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: Data)
    {
        photoImageView.image = UIImage(data: image)
        
        
    }
    public func configure(debug imageName: String){
        photoImageView.image = UIImage(named: imageName)
    }
    
}
