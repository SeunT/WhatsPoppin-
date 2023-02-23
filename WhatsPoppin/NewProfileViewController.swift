//
//  NewProfileViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/22/23.
//

import UIKit
import FirebaseDynamicLinks
class NewProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
//private var userEvents =
    var User:User_info =  User_info()
    
    private var headerViewModel: ProfileHeaderViewModel?
    
    var gridTabSelected: Bool = true
 
    var currentUser: Bool
    var currId: String

    init(currentUser: Bool, currId:String) {
        //viewing another users profile
        self.currId = currId
           self.currentUser = currentUser
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           //viewing current users profile
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

      fetchProfileInfo()
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
    private func fetchProfileInfo() {
     

        let group = DispatchGroup()

        // Fetch Profiel Header Info

        var profilePictureUrl: URL?
        var buttonType: ProfileButtonType = .edit
        var followers = 0
        var following = 0
        var name: String?
        var bio: String?

        // Counts (3)
        group.enter()
        DatabaseManager.shared.getUserCounts(uuid: currId) { result in
            defer {
                group.leave()
            }
            followers = result.followers
            following = result.following
        }


        // Bio, name
        DatabaseManager.shared.getUserInfo(uuid: currId) { userInfo in
            name = userInfo?.name
            bio = userInfo?.bio
        }

        // Profile picture url
        group.enter()
        DatabaseManager.shared.profilePictureURL(for: currId) { url in
            defer {
                group.leave()
            }
            profilePictureUrl = url
        }

        // if profile is not for current user,
        if !currentUser {
            // Get follow state
            group.enter()
            DatabaseManager.shared.isFollowing(targetUuid: currId) { isFollowing in
                defer {
                    group.leave()
                }
                print(isFollowing)
                buttonType = .follow(isFollowing: isFollowing)
            }
        }

        group.notify(queue: .main) {
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureUrl: profilePictureUrl,
                followerCount: followers,
                followingCount: following,
                buttonType: buttonType,
                name: name,
                bio: bio
            )
            self.collectionView?.reloadData()
        }
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
        
//        if(!currentUser)
//        {
//            profileHeader.delegate = self
////            profileHeader.disableEdit()
//            //with other user
//            profileHeader.addOtherUserDara(id: currId){
//                res in
//
//                print(res)
//            }
//
//
//        }
//        else
//        {
//            //with current user
//            profileHeader.addUserData()
//            profileHeader.delegate = self
//        }
//        
        if let viewModel = headerViewModel {
            profileHeader.configure(with: viewModel)
            profileHeader.delegate = self
        }
        
        return profileHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 && currentUser
//        {
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2)
//
//        }
//        else if section == 0 && !(currentUser)
//        {
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/3)
//        }
        if section == 0
       {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/2.2)

       }
       return CGSize(width: collectionView.frame.width, height: 40)
    }
    
}
extension NewProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate
{
    func profileHeaderDidTapShare(_ containerView: ProfileInfoHeaderCollectionReusableView) {
        let ID = self.currId
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.medullalogic.com"
        components.path = "/whatspoppin/profiles"
        
        let  items = URLQueryItem(name: "profileID", value: ID)
        components.queryItems = [items]
        
        guard let linkParameter = components.url else {return}
        print("I am sharing \(linkParameter.absoluteString)")
        
        //Create the big dynamic link
        guard let sharelink = DynamicLinkComponents(link: linkParameter, domainURIPrefix: "https://whatspoppinapp.page.link") else {
            print("Couldn't create FDL components")
            return
        }
        if let myBundleId = Bundle.main.bundleIdentifier {
            sharelink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
     
        sharelink.iOSParameters?.appStoreID = "1664587337"
//        sharelink.iOSParameters?.fallbackURL = URL(string: "https://www.medullalogic.com/whatspoppin")
        sharelink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharelink.socialMetaTagParameters?.title = "What's Poppin ?"
        sharelink.socialMetaTagParameters?.imageURL = URL(string: "https://static.wixstatic.com/media/058c2d_4763370fc5ea45e2a8da998f8cc0248e~mv2.jpeg/v1/fill/w_636,h_1284,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/img1.jpeg")
        sharelink.socialMetaTagParameters?.descriptionText = "Im bouta get active tonight"
        
        guard let longURL = sharelink.url else { return }
        print("The long dynamic link is \(longURL.absoluteString)")
        
        sharelink.shorten{ [weak self] (shortURL, warnings, error) in
            if let error = error {
                print("Error creating short link: \(error.localizedDescription)")
                self?.showShareSheet(url: longURL)
                return
            }

            if let warnings = warnings {
                for warning in warnings {
                    print("FDL Warning: \(warning)")
                }
            }
            guard let shortURL = shortURL else {
                print("No short link available")
                return
            }
            print("Dynamic link: \(shortURL.absoluteString)")
            self?.showShareSheet(url: shortURL)
              // You can now share the shortURL with your users
          }
    }
    
    func showShareSheet(url: URL)
    {
        let promoText = "Follow me on Whats Poppin"
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        present(activityVC, animated: true)
        
    }
    func profileHeaderDidTapFollowers(_ containerView: ProfileInfoHeaderCollectionReusableView) {
        let vc = ListViewController(type: .followers(user: currId))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapFollowing(_ containerView: ProfileInfoHeaderCollectionReusableView) {
        let vc = ListViewController(type: .following(user: currId))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditProfile(_ containerView: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc),animated: true)
    }
    
    func profileHeaderDidTapFollow(_ containerView: ProfileInfoHeaderCollectionReusableView) {
        DatabaseManager.shared.updateRelationship(
            state: .follow,
            for: currId
        ) { [weak self] success in
            if !success {
                print("failed to follow")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
    
    func profileHeaderDidTapUnFollow(_ containerView: ProfileInfoHeaderCollectionReusableView) {
        DatabaseManager.shared.updateRelationship(
            state: .unfollow,
            for: currId
        ) { [weak self] success in
            if !success {
                print("failed to unfollow")
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }
    
//    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView)
//    {
//        var mockData = [userRelationship]()
//        for x in 0..<10{
//            mockData.append(userRelationship(name: "joe", type: x % 2 == 0 ? .following : .not_following))
//        }
//        let vc = ListViewController(data:mockData)
//        vc.title = "Following"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//
//    }
//
//    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
//
//        var mockData = [userRelationship]()
//        for x in 0..<10{
//            mockData.append(userRelationship(name: "joe", type: x % 2 == 0 ? .following : .not_following))
//        }
//        let vc = ListViewController(data:mockData)
//        vc.title = "Followers"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func profileHeaderDidTapEditButton(_ header: ProfileInfoHeaderCollectionReusableView) {
//        let vc = EditProfileViewController()
//        vc.delegate = self
//        present(UINavigationController(rootViewController: vc),animated: true)
//    }
    
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
        headerViewModel = nil
        fetchProfileInfo()
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
