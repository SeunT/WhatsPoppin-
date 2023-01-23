//
//  NewProfileViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/22/23.
//

import UIKit

class NewProfileViewController: UIViewController {
    private var collectionView: UICollectionView?
    
//private var userEvents =
    var User:User_info =  User_info()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
      
        configureNavigationbar()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top:0, left:1, bottom:0, right:1)
        let size = (view.frame.width - 4)/3
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView?.backgroundColor = .red
        
        //Cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        //Headers
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
        collectionView?.register(ProfileTabsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    private func configureNavigationbar()
    {
        let bar1 = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(didTapSettingsButton))
        let bar2 = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .done, target: self, action: #selector(didTapCreateEventButton))
                                   
        navigationItem.rightBarButtonItems = [bar1,bar2]
    }
    @objc private func didTapSettingsButton()
    {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapCreateEventButton()
    {
        let vc = Step1ViewController()
        vc.title = "Step1"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        let user = User.getUserEventData()
         print(section)
        let count = user.count
           
        if section == 0
        {
            return 0
        }
        
//        if count == 0
//        {
//            let noDataLabel = UILabel()
//            noDataLabel.text = "No active events"
//            noDataLabel.textColor = UIColor.black
//            noDataLabel.textAlignment = .center
//            noDataLabel.font = UIFont(name: "HelveticaNeue", size: 18)
//            noDataLabel.translatesAutoresizingMaskIntoConstraints = false
//            collectionView.backgroundView = noDataLabel
//            noDataLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
//            noDataLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -40).isActive = true
//
//            let noDataImage = UIImageView()
//            noDataImage.image = UIImage(systemName: "calendar")
//            noDataImage.contentMode = .scaleAspectFit
//            noDataImage.translatesAutoresizingMaskIntoConstraints = false
//            collectionView.backgroundView?.addSubview(noDataImage)
//            noDataImage.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor, constant: 130).isActive = true
//            noDataImage.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: 80).isActive = true
//            noDataImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
//            noDataImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        }
  
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = .systemBlue
        let user = User.getUserEventData()
        let event = user[indexPath.item].value(forKey: "images") as! [Data]
        let firstImage =  event.first
        cell.configure(with: firstImage!)
//        cell.configure(debug: "testimg")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        //get the model and open event controller
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        if indexPath.section == 1
        {
            let tabHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier, for: indexPath) as! ProfileTabsCollectionReusableView
            tabHeader.delegate = self
            
            return tabHeader
        }
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        
        profileHeader.delegate = self
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0
        {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
            
        }
       return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}
extension NewProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate
{
    func profileHeaderDidTapEditButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}
extension NewProfileViewController: ProfileTabsCollectionReusableViewDelegate
{
    func didTapGridButtonTab() {
        //reload collection view
    }
    
    func didTapListButtonTab() {
        //reload collectionview
    }
    
   
    
}

