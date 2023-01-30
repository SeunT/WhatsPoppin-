//
//  ProfileViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//
import UIKit
import Firebase
import CoreData
import SDWebImage
class ProfileViewController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  
    
  
    let db = Firestore.firestore()
    var imagdat:Data!
    var username:String!
    
    


    var User:User_info =  User_info()
    
    let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
    let name_label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    let bio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.text = "Niche free yourself"
        return label
    }()
    let activeEvents: UILabel = {
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 0.9)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Active Events"
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = customColor
        return label
    }()

    let underlineView: UIView = {
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = customColor
        return view
    }()
    let editProfileButton: UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(customColor, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = customColor.cgColor
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return button
    }()
 
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing =  0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.layer.borderColor = UIColor.white.cgColor
        collectionView.layer.borderWidth = 1
        return collectionView
       }()
    override func viewDidLoad() {
        
       
        super.viewDidLoad()

        let user = User.getUserData()
        name_label.text = user?.name!
        
//        profileImageView.image = UIImage(data: (user?.pfp)!)
//
//        imagdat = user?.pfp!
        // Do any additional setup after loading the view.
        configure_const()

    }
//    backgroun
//    override func viewDidAppear(_ animated: Bool) {
//        configure_const()
//        collectionView.reloadData()
//    }
//
    
    func configure_const() {
        view.addSubview(profileImageView)
        view.addSubview(name_label)
        view.addSubview(bio)
        view.addSubview(editProfileButton)
        view.addSubview(collectionView)
        view.addSubview(activeEvents)
        view.addSubview(underlineView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
        let size = view.bounds.width/4
        profileImageView.frame = CGRect(x: (view.bounds.width-size)/2,
                                  y: 100,
                                  width: size,
                                  height: size)
        profileImageView.layer.cornerRadius = size/2
         profileImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.widthAnchor.constraint(equalToConstant: size),
            profileImageView.heightAnchor.constraint(equalToConstant: size)
        ])
        // Add constraints for name_label
        name_label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name_label.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
            name_label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            name_label.widthAnchor.constraint(equalToConstant: 150),
            name_label.heightAnchor.constraint(equalToConstant: 30)
        ])
        bio.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bio.leftAnchor.constraint(equalTo: profileImageView.leftAnchor),
                bio.topAnchor.constraint(equalTo: name_label.bottomAnchor, constant: 10),
                bio.widthAnchor.constraint(equalToConstant: 150),
                bio.heightAnchor.constraint(equalToConstant: 30)
            ])

        NSLayoutConstraint.activate([
            editProfileButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                 editProfileButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                 editProfileButton.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 10),
                 editProfileButton.heightAnchor.constraint(equalToConstant: 30)
             ])
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width:view.frame.size.width, height: view.frame.size.height)
//        collectionView.collectionViewLayout = layout
    
        NSLayoutConstraint.activate([
            activeEvents.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            activeEvents.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activeEvents.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 25),
            underlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            underlineView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 45),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
      
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 0),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               ])

    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var user = User.getUserEventData()
         
        let count = user.count
            
        if count == 0
        {
            let noDataLabel = UILabel()
            noDataLabel.text = "No active events"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            noDataLabel.font = UIFont(name: "HelveticaNeue", size: 18)
            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundView = noDataLabel
            noDataLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
            noDataLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -40).isActive = true
            
            let noDataImage = UIImageView()
            noDataImage.image = UIImage(systemName: "calendar")
            noDataImage.contentMode = .scaleAspectFit
            noDataImage.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundView?.addSubview(noDataImage)
            noDataImage.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: 130).isActive = true
            noDataImage.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 80).isActive = true
            noDataImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
            noDataImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
  
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.isUserInteractionEnabled = true
        cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = cell.bounds
        let user = User.getUserEventData()
    
 
        print(indexPath.item)

        let event = user[indexPath.item].value(forKey: "images") as! [Data]
        let firstImage =  event.first

        let originalImage = UIImage(data: firstImage!)
        let originalSize = originalImage!.size
        let cropSize = min(originalSize.width, originalSize.height)
        let x = (originalSize.width - cropSize) / 2
        let y = (originalSize.height - cropSize) / 2
        let cropRect = CGRect(x: x, y: y, width: cropSize, height: cropSize)
        let croppedImage = originalImage?.cgImage?.cropping(to: cropRect)

        imageView.image = UIImage(cgImage: croppedImage!)
//        imageView.image = UIImage(data: imagdat)
        cell.contentView.addSubview(imageView)
        imageView.frame = cell.bounds
        
        
        return cell
        
    }
    
    @objc func cellTapped(index indexpath:Int)
    {
       print("cell tapped")
    }
    
    @objc func editProfileButtonTapped()
    {
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        UIView.animate(withDuration: 0.1, animations: {
         
                self.editProfileButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.editProfileButton.setTitleColor(customColor.withAlphaComponent(0.4), for: .normal)
                self.editProfileButton.layer.borderColor = customColor.withAlphaComponent(0.4).cgColor
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.editProfileButton.transform = CGAffineTransform.identity
                    self.editProfileButton.setTitleColor(customColor, for: .normal)
                    self.editProfileButton.layer.borderColor = customColor.cgColor
                }
            }
        performSegue(withIdentifier: "editview", sender: nil)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize(width: view.frame.width/3, height: view.frame.width/3)
    }
}
