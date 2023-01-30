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
    
    var gridTabSelected: Bool = true
 
    var currentUser: Bool
    var currId: String

    init(currentUser: Bool, currId:String) {
        self.currId = currId
           self.currentUser = currentUser
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           self.currId = ""
           self.currentUser = true
           super.init(coder: coder)
       }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
      
        if(currentUser)
        {
            configureNavigationbar()
        }

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
        override func viewDidAppear(_ animated: Bool)
        {
            //reload
            collectionView?.reloadData()

    
            
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
        let vc = Step3ViewController()
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
        //check for other users here too
        print("this is section: \(section)")
        var count = 0
        if(currentUser)
        {
            let user = User.getUserEventData()
            
            
             count = user.count
            
        }
        else
        {
        OtherUserCache.shared.getEvents(userID: currId)
            {
                res in
                count = res.count
                collectionView.reloadData()
            }
            
        }
        
        if section == 0
        {
            return 0
        }
        if(!gridTabSelected)
        {
            return 0
            
        }
        
//
        
  
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = .systemBackground
    
        if(currentUser)
        {
            let user = User.getUserEventData()
            guard let event = user[indexPath.item].value(forKey: "images") as? [String] else {
                print("Images attribute is not of type [String].")
                return cell
            }
            guard let firstImage = event.first else {
                print("No first image found.")
                return cell
            }
            guard let url = URL(string: firstImage) else {
                print("Invalid URL string.")
                return cell
            }
            cell.configure(with: url)
        }
        else
        {
        User.getOtherUserEventData(ID: currId)
            {res in
                
                
        
            print(res[indexPath.item].eventimage?.first)

            guard let url = res[indexPath.item].eventimage?.first?.absoluteURL else
            {
                print("error getting URL for cell in opening other profile")
                return
            }
            cell.configure(with: url)
            }

        }
//        cell.configure(debug: "testimg")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let event = User.getUserEventData()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let eventview = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventViewController
    
     
        
        if(currentUser)
        {
            eventview.delegate = self
            eventview.eventID = event[indexPath.item].uuid
            navigationController?.pushViewController(eventview, animated: true);
        }
        else
        {
            OtherUserCache.shared.getEvents(userID: currId)
            {
                res in
                let eID = res[indexPath.item].eventID!
                eventview.eventID = eID
                self.navigationController?.pushViewController(eventview, animated: true);
            }
            
        }
//        let rightButton = UIBarButtonItem(title: "Delete Event", style: .plain, target: self, action: #selector(eventview.rightButtonTapped))
//        rightButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
//        eventview.navigationItem.setRightBarButton(rightButton, animated: true)
     
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
            if collectionView.numberOfItems(inSection: indexPath.section) == 0 {
                let noDataImage = UIImageView()
                let noDataLabel = UILabel()
                
                let backgroundView = UIView()
                collectionView.backgroundView = backgroundView
                
                backgroundView.addSubview(noDataImage)
                backgroundView.addSubview(noDataLabel)
              
                noDataImage.image = UIImage(systemName: "calendar.circle")
                noDataImage.tintColor = .label
                noDataImage.contentMode = .scaleAspectFit
                noDataImage.translatesAutoresizingMaskIntoConstraints = false
               
                noDataImage.topAnchor.constraint(equalTo: tabHeader.bottomAnchor,constant: 20).isActive = true
                noDataImage.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
                noDataImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
                noDataImage.heightAnchor.constraint(equalToConstant: 100).isActive = true

                noDataLabel.text = "No events yet"
                noDataLabel.textColor = .label
                noDataLabel.textAlignment = .center
                noDataLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
                noDataLabel.translatesAutoresizingMaskIntoConstraints = false
                
                noDataLabel.topAnchor.constraint(equalTo: noDataImage.bottomAnchor, constant: 10).isActive = true
                noDataLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
              }
            else
            {
                collectionView.backgroundView = nil
            }
            return tabHeader
        }
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        
        if(!currentUser)
        {
            profileHeader.disableEdit()
            //with other user
            profileHeader.addOtherUserDara(id: currId){
                res in

                print(res)
            }
           

        }
        else
        {
            //with current user
            profileHeader.addUserData()
            profileHeader.delegate = self
        }
        
       
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && currentUser
        {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
            
        }
        else if section == 0 && !(currentUser)
        {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/4)
        }
       return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}
extension NewProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate
{
    func profileHeaderDidTapEditButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
}
extension NewProfileViewController: ProfileTabsCollectionReusableViewDelegate
{
    func didTapGridButtonTab() {
        //reload collection view
        gridTabSelected = true
               collectionView?.reloadData()
    }
    
    func didTapListButtonTab() {
        //reload collectionview
        
        gridTabSelected = false
              collectionView?.reloadData()
    }
}

extension NewProfileViewController: ReloadDelegate
{
    func reloadData() {
//
//        let vc = ProfileInfoHeaderCollectionReusableView()
//        vc.addUserData()
////        vc.self.setNeedsLayout()
//        vc.layoutIfNeeded()
        collectionView?.reloadData()
       
        
    }
}

extension NewProfileViewController: EventViewControllerDelegate
{
    func createBarButtonItem(for eventViewController: EventViewController) {
        let rightButton = UIBarButtonItem(title: "Delete Event", style: .plain, target: eventViewController, action: #selector(eventViewController.rightButtonTapped))
        rightButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
           eventViewController.navigationItem.setRightBarButton(rightButton, animated: true)
       
    }
}
