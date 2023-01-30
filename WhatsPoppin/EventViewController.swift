//
//  EventViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/4/23.
//

import UIKit
import SDWebImage

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
        tableView.backgroundColor = .systemBlue
        return tableView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
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
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.up.right.diamond.fill"), for: .normal)
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
        label.text = "testing"
        return label
    }()
    let loadingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
            dateFormatter.dateFormat = "h a"
            let hourAndAmPm = dateFormatter.string(from: date)
            let ampm = dateFormatter.string(from: date)
           // let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            self.timeLabel.text = "\(month) \(day) at \(hourAndAmPm)"
            self.final_event = Evnt
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
            //        tableView.rowHeight = UITableView.automaticDimension
            //        tableView.estimatedRowHeight = 1000
            self.tableView.register(EventProfileTableViewCell.self, forCellReuseIdentifier: EventProfileTableViewCell.identifier)
        }
        collectionView.dataSource = self
       
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        configureView()
        delegate?.createBarButtonItem(for: self)
        
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    @objc func rightButtonTapped()
    {
        let DeleteAlert = UIAlertController(title: "Deleting...", message: nil, preferredStyle: .alert)
    
        let actionSheet = UIAlertController(title: "Delete", message: "Are you sure you want to Delete this event?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: { [self]_ in
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
    


    
}
extension EventViewController{
    
    func configureView() {
        
        configureScrollView()
        configureCollectionView()
//        configureTableView()
    }
//    func configureTableView()
//    {
//        NSLayoutConstraint.activate([
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            tableView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
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
            collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -topPadding),
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
        
        scrollView.addSubview(locationButton)

        timeLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 10).isActive = true

        // Constraints for location button
           locationButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true
        locationButton.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: -5).isActive = true
  
        let firstString = "Lorem Ipsum is simply "
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: firstAttributes)

        let secondString = "dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nContrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old."

        let secondAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 20, weight: .regular),
            .foregroundColor: UIColor.gray
        ]

        let secondAttributedString = NSMutableAttributedString(string: secondString, attributes: secondAttributes)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2

        let attributedString = NSMutableAttributedString(attributedString: firstAttributedString)
        attributedString.append(secondAttributedString)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        
        descriptionLabel.attributedText = attributedString
    
        let bottomView = UIView()
            
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bottomView)
        
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -50.0)
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
            bottomView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20.0),
          bottomView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           bottomView.heightAnchor.constraint(equalToConstant: 60)
        ])

        bottomView.backgroundColor = .red

        


        bottomView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            tableView.heightAnchor.constraint(equalTo: bottomView.heightAnchor),
            tableView.widthAnchor.constraint(equalTo: bottomView.widthAnchor)
        ])
//        tableView.rowHeight = 25
        tableView.frame = bottomView.bounds
//        tableView.rowHeight = tableView.frame.height
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
}

extension EventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left:0, bottom:0, right:0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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

