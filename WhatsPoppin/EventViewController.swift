//
//  EventViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/4/23.
//

import UIKit
import SDWebImage
import FirebaseDynamicLinks
protocol EventViewControllerDelegate {
    func createBarButtonItem(for eventViewController: EventViewController)
}
class EventViewController: UIViewController, UIScrollViewDelegate{
    var delegate: EventViewControllerDelegate?
    var imgArr = [URL]()
    var final_event:Event!
    var eventID:String!
    var Eventt:Events = Events()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    let activitySpinner: UIActivityIndicatorView = {
            let activitySpinner = UIActivityIndicatorView(style: .medium)
            activitySpinner.translatesAutoresizingMaskIntoConstraints = false
            activitySpinner.hidesWhenStopped = true
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            activitySpinner.color = customColor
            return activitySpinner
        }()
    let popUpMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.tintColor = customColor
        return button
    }()
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.up.right.diamond.fill"), for: .normal)
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.tintColor = customColor
        return button
    }()
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.tintColor = customColor
        return button
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        label.textColor = customColor
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        label.textColor = customColor
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    let loadingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
//    override func viewDidAppear(_ animated: Bool) {
//        tableView.reloadData()
//    }
    // MARK: - View Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let group = DispatchGroup()
        group.enter()
    
        Eventt.getEventData(eventID: eventID) {
            Evnt in
//
//            self.descriptionLabel.text = Evnt.eventdis
            let date = Evnt.eventime!.dateValue()
            //let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            let month = dateFormatter.string(from: date)
            let calendar = Calendar.current
            dateFormatter.dateFormat = "h"
            let hour = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "a"
            let ampm = dateFormatter.string(from: date)
           // let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            dateFormatter.dateFormat = "mm"
            let min = dateFormatter.string(from: date)
            self.timeLabel.text = "\(month) \(day) at \(hour):\(min) \(ampm)"
            self.final_event = Evnt
            let secondString = Evnt.eventdis!

            let secondAttributes: [NSAttributedString.Key: Any] = [
                .font : UIFont.systemFont(ofSize: 20, weight: .regular),
                .foregroundColor: UIColor.label
            ]

            let secondAttributedString = NSMutableAttributedString(string: secondString, attributes: secondAttributes)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.2

            let attributedString = NSMutableAttributedString(attributedString: secondAttributedString)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            
            self.descriptionLabel.attributedText = attributedString
            group.leave()
            self.Eventt.getEventImages(eventID: self.eventID, Evnt: Evnt) {
                event in
                
                    self.final_event = event
                    self.imgArr = event.eventimage!
                DispatchQueue.main.async {
//                    self.activitySpinner.stopAnimating()
//                    self.activitySpinner.isHidden = true
                    self.collectionView.reloadData()
                }
            }
            
        }
        group.notify(queue: .main) {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(EventProfileTableViewCell.self, forCellReuseIdentifier: EventProfileTableViewCell.identifier)
            self.tableView.reloadData()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    
       
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        configureView()

        delegate?.createBarButtonItem(for: self)
        configureButtonMenu()
        
//        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
//        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func configureButtonMenu() {
        let menu = UIMenu(title: "Options", children: [
            UIAction(title: "Show Location ", image: UIImage(systemName: "arrow.up.right.diamond.fill")) { _ in
                self.locationButtonTapped()
            },
            UIAction(title: "Share Event ", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareButtonTapped()
            }
        ])
        popUpMenuButton.menu = menu
        popUpMenuButton.showsMenuAsPrimaryAction = true
    }
    

    @objc func locationButtonTapped() {
        if let addy = final_event.addy
        {
            let encodedAddress = addy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print(encodedAddress)
            let urlString = "http://maps.apple.com/?address=\(encodedAddress)"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
    @objc func shareButtonTapped() {
       
        guard let ID = self.eventID else {return}
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.medullalogic.com"
        components.path = "/whatspoppin/profiles"
        
        let  items = URLQueryItem(name: "eventID", value: ID)
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
        sharelink.iOSParameters?.fallbackURL = URL(string: "https://www.medullalogic.com/whatspoppin")
        sharelink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharelink.socialMetaTagParameters?.title = "What's Poppin ?"
        sharelink.socialMetaTagParameters?.imageURL = URL(string: "https://static.wixstatic.com/media/058c2d_4763370fc5ea45e2a8da998f8cc0248e~mv2.jpeg/v1/fill/w_636,h_1284,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/img1.jpeg")
        sharelink.socialMetaTagParameters?.descriptionText = "Im bouta get active tonight"
        
        guard let longURL = sharelink.url else { return }
        print("The long dynamic link is \(longURL.absoluteString)")
        
        sharelink.shorten{ [weak self] (shortURL, warnings, error) in
            if let error = error {
                print("Error creating short link: \(error.localizedDescription)")
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
        let promoText = "This is the move tonight"
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        present(activityVC, animated: true)
        
    }
    
    @objc func rightButtonTapped()
    {
        let DeleteAlert = UIAlertController(title: "Deleting...", message: nil, preferredStyle: .alert)
    
        let actionSheet = UIAlertController(title: "Delete", message: "Are you sure you want to Delete this event?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: { [self]_ in
            //update boolean to true so the map spawns on the users current location
            UserDefaults.standard.set(true, forKey: "updateMap")
            present(DeleteAlert, animated: true, completion: nil)
            
            Eventt.deleteEvent(eventID: final_event.eventID!, userID: final_event.userid!){
                DeleteAlert.dismiss(animated: true)
                
                let controller = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
                self.view.window?.rootViewController = controller
            }
            
        }))
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        present(actionSheet, animated: true)
    }
    
    func configureView() {
        configureScrollView()
        configureCollectionView()
    }

    func configureScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
       
    }
    func configureCollectionView() {
        
           scrollView.addSubview(collectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:view.frame.size.width, height: view.frame.size.height)
        collectionView.collectionViewLayout = layout
        
        let topPadding = view.safeAreaInsets.top
        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -topPadding),
            collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            collectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
               ])
        // Add constraints for activity spinner
//        collectionView.addSubview(activitySpinner)
//        activitySpinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
//        activitySpinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
//        activitySpinner.startAnimating()
//
//
        loadingImage.addSubview(activitySpinner)

        // Set constraints for the activity spinner
        activitySpinner.centerXAnchor.constraint(equalTo: loadingImage.centerXAnchor).isActive = true
        activitySpinner.centerYAnchor.constraint(equalTo: loadingImage.centerYAnchor).isActive = true
        activitySpinner.startAnimating()
        
        scrollView.addSubview(timeLabel)
        
//        scrollView.addSubview(locationButton)
//        scrollView.addSubview(shareButton)

        scrollView.addSubview(popUpMenuButton)
        
        timeLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 5).isActive = true

        //constrain the pop up menu
        NSLayoutConstraint.activate([
            popUpMenuButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            popUpMenuButton.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -5)
        
        ])
        
        // Constraints for location button
//           locationButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true
//        locationButton.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -5).isActive = true
//
//        NSLayoutConstraint.activate([
//            shareButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 5),
//            shareButton.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -5)
//        ])
//
//        let firstString = "Lorem Ipsum is simply "
//        let firstAttributes: [NSAttributedString.Key: Any] = [
//            .font : UIFont.systemFont(ofSize: 20, weight: .medium),
//            .foregroundColor: UIColor.black
//        ]
//        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: firstAttributes)

      
    
        let bottomView = UIView()
            
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bottomView)
        
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100.0)
               ])
        
//        scrollView.addSubview(tableView)
//        NSLayoutConstraint.activate([
//                    tableView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                    tableView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
//                    tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20.0),
//                    tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20.0)
//                       ])
//        tableView.frame = CGRect(x: 0, y: descriptionLabel.frame.maxY, width: scrollView.frame.width, height: scrollView.frame.height - descriptionLabel.frame.maxY)
       

        NSLayoutConstraint.activate([
           bottomView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
           bottomView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
//            bottomView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20.0),
          bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
           bottomView.heightAnchor.constraint(equalToConstant: 60)
        ])


        


        bottomView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            tableView.heightAnchor.constraint(equalTo: bottomView.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: bottomView.widthAnchor)
        ])

        tableView.frame = bottomView.bounds
        tableView.rowHeight = tableView.frame.height
       }
 
}
extension EventViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return imgArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        collectionView.addSubview(cell)
        
        let imageView = UIImageView()
          imageView.translatesAutoresizingMaskIntoConstraints = false
          imageView.contentMode = .scaleAspectFit
          imageView.tag = 111
          cell.addSubview(imageView)
        
        NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
             cell.topAnchor.constraint(equalTo: collectionView.topAnchor),
             cell.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
             cell.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
             cell.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
         ])
        if let vc = cell.viewWithTag(111) as? UIImageView{
//            vc.image = imgArr[indexPath.row]
//            vc.sd_setImage(with: imgArr[indexPath.row], placeholderImage: nil, options: .highPriority) { (image, error, cacheType, url) in
//                self.activitySpinner.stopAnimating()
//            }
            print(imgArr[indexPath.item])
            print(imgArr[indexPath.row])
            vc.sd_setImage(with: imgArr[indexPath.row], placeholderImage: nil, options: SDWebImageOptions.progressiveLoad)
          //  vc.sd_setImage(with: imgArr[indexPath.row], placeholderImage: UIImage(named: "greyBox"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if !cell.isHighlighted {

                let selectedImageURL = imgArr[indexPath.item]
                //        let imageView = selectedImage as! UIImageView
                //        var newImageView:UIImageView
                let newImageView = UIImageView()
                newImageView.sd_setImage(with: selectedImageURL, completed: nil)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true

            }
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventProfileTableViewCell.identifier, for: indexPath) as! EventProfileTableViewCell

        cell.configure(nm: final_event.username!, pho: final_event.userimg!)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //check if current user matches this user
        let currUserID = (UserCache.shared.getUser()?.uuid)!
        let otherUserID = final_event.userid!
        if(otherUserID == currUserID)
        {
            let vc = NewProfileViewController(currentUser: true, currId: currUserID)
            navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = NewProfileViewController(currentUser: false, currId: otherUserID)
            navigationController?.pushViewController(vc, animated: true)
            
        }        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

