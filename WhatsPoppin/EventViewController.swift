//
//  EventViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/4/23.
//

import UIKit

class EventViewController: UIViewController, UIScrollViewDelegate{
    
    var imgArr = [UIImage]()
    var final_event:Event!
    var eventID:String!
    var Eventt:Events = Events()
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
    
    // MARK: - View Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
      
        configureView()
        
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
            self.Eventt.getEventImages(eventID: self.eventID, Evnt: Evnt) {
                event in
                    self.final_event = event
                    self.imgArr = event.eventimage!
                DispatchQueue.main.async {
                    self.activitySpinner.stopAnimating()
                    self.activitySpinner.isHidden = true
                    self.collectionView.reloadData()
                }
            }
            
        }
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
    


    
}


extension EventViewController{
    
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
            collectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -topPadding),
            collectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
               ])
        // Add constraints for activity spinner
        collectionView.addSubview(activitySpinner)
        activitySpinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        activitySpinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
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

        let secondString = "dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\n\nContrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. \n\nLorem Ipsum comes from sections 1.10.32 and 1.10.33 of 'de Finibus Bonorum et Malorum' (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, 'Lorem ipsum dolor sit amet..', comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from 'de Finibus Bonorum et Malorum' by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham. Where can I get some? There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."

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
    
        
        scrollView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20.0)
               ])
        
           
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
            vc.image = imgArr[indexPath.row]
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

