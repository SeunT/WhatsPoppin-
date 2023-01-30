//
//  Step4ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/17/22.
//

import UIKit
import CoreLocation
import Firebase
import Photos
import PhotosUI
protocol Step4ViewControllerDelegate: AnyObject
{
    func step4viewcontroller(_ vc: Step4ViewController, description perm_desc: String?, date_e perm_date: Date)
    
}
class Step4ViewController: UIViewController, PHPickerViewControllerDelegate, UITextViewDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        }
    private let time: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Time"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.numberOfLines = 1
        return label
    }()
    private let address: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Address"
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.numberOfLines = 1
        return label
    }()
    private let desc: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description"
        label.textColor = .label
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.numberOfLines = 1
        return label
    }()
    private let photo1:UIButton =
    {
        let button = UIButton()
        button.clipsToBounds = true
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.tintColor = customColor
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        return button
    }()
    private let create_button:UIButton =
    {
        let button = UIButton()
        button.clipsToBounds = true
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.setTitle("Create Event", for: .normal)
        button.setTitleColor(customColor, for: .normal)
        return button
    }()
    
//    @IBOutlet weak var time: UILabel!
//    @IBOutlet weak var address: UILabel!
//    @IBOutlet weak var desc: UILabel!
//    @IBOutlet weak var photo1: UIButton!
//    @IBOutlet weak var slider: UICollectionView!
    let slider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    let pageView: UIPageControl = {
        let pageView = UIPageControl()
        pageView.translatesAutoresizingMaskIntoConstraints = false
        return pageView
    }()
    
//    @IBOutlet weak var pageView: UIPageControl!
//    @IBOutlet weak var create_button: UIButton!
    let userDefault = UserDefaults.standard
    weak var delegate: Step4ViewControllerDelegate?
    var User:User_info =  User_info()
    var Event:Events = Events()
    var location : CLLocationCoordinate2D?
    
    private let perm_addy: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    private let  perm_desc:UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.isScrollEnabled = false
        textview.backgroundColor = .systemGray6
        textview.font = UIFont(name: "HelveticaNeue", size: 15)
        return textview
    }()
    private let perm_date: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.sizeToFit()
//        date.preferredDatePickerStyle = .whe
        return date
    }()
//    @IBOutlet weak var perm_date: UIDatePicker!
//    @IBOutlet weak var perm_desc: UITextView!
//    @IBOutlet weak var perm_addy: UILabel!
//    private let Time_date: UIDatePicker = {
//        let date = UIDatePicker()
//        date.translatesAutoresizingMaskIntoConstraints = false
//        return date
//    }()
//
    var geoP:GeoPoint!
    var event_desc:String!
    var event_date:Date!
    var event_addy:String!
    var imgArr = [UIImage]()
    @IBOutlet weak var going: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        perm_desc.delegate = self
        perm_date.setDate(event_date, animated: false)
        perm_addy.text = event_addy
        perm_desc.text = event_desc
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        slider.dataSource = self
        slider.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        configure_view()
        configure_constraints()
        create_button.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        photo1.addTarget(self, action: #selector(Photo1), for: .touchUpInside)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func configure_view()
    {
        view.addSubview(slider)
        view.addSubview(pageView)
        view.addSubview(time)
        view.addSubview(address)
        view.addSubview(desc)
        view.addSubview(photo1)
        view.addSubview(create_button)
        view.addSubview(perm_addy)
        view.addSubview(perm_desc)
        view.addSubview(perm_date)
    }
    func configure_constraints()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:view.frame.size.width, height: view.frame.size.height)
        slider.collectionViewLayout = layout
        
        slider.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
              slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              slider.widthAnchor.constraint(equalTo: view.widthAnchor),
              slider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
          ])
        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10),
            pageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        photo1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photo1.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 0),
            photo1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photo1.widthAnchor.constraint(equalToConstant: 30),
            photo1.heightAnchor.constraint(equalToConstant: 30)
        ])
     
        // Add constraints for time label
        time.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            time.topAnchor.constraint(equalTo: photo1.bottomAnchor, constant: 20),
        ])

        // Add constraints for perm_date
        perm_date.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            perm_date.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            perm_date.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 10),
            perm_date.heightAnchor.constraint(equalToConstant: 40)
        ])
     

        // Add constraints for address label
        address.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            address.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            address.topAnchor.constraint(equalTo: perm_date.bottomAnchor, constant: 20),
            address.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Add constraints for perm_addy
        perm_addy.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            perm_addy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            perm_addy.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 10),
            perm_addy.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Add constraints for desc label
        desc.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            desc.topAnchor.constraint(equalTo: perm_addy.bottomAnchor, constant: 20),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        // Add constraints for perm_desc
          perm_desc.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              perm_desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              perm_desc.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 10),
              perm_desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              perm_desc.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
          ])
          //Add constraints for create_button
          create_button.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              create_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//              create_button.topAnchor.constraint(equalTo: perm_desc.bottomAnchor, constant: 10),
              create_button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              create_button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
          ])
      
      }
    
    
//    @IBAction func Photo1(_ sender: Any) {
    @objc private func Photo1()
    {
        imgArr.removeAll()
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 4
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        print(perm_desc.text!)
        delegate?.step4viewcontroller(self, description: self.perm_desc.text!, date_e: self.perm_date.date)
        
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self)
            { reading, error in
                
                defer
                {
                    group.leave()
                    
                }
                guard let image = reading as? UIImage, error == nil else{
                    return
                }
       
                self.imgArr.append(image)
            }
        }
//        DispatchQueue.main.async {
//            print(self.imgArr.count)
//            self.slider.reloadData()
//            self.pageView.numberOfPages = self.imgArr.count
//            self.pageView.currentPage = 0
//        }
        group.notify(queue: .main) {
            print(self.imgArr.count)
            self.slider.reloadData()

            self.pageView.numberOfPages = self.imgArr.count
            self.pageView.currentPage = 0
            
            

        }
      
    }
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {

        return self.textLimit(existingText: textView.text,
                              newText: text,
                              limit: 100)
    }

    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {

        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
//    @IBAction func createEvent(_ sender: Any)
    @objc private func createEvent()
    {
    //to-do validate all fields are not empty before this
        let error = validateFields()
        
        
        if imgArr.isEmpty {
            
            let alert = UIAlertController(title: "Please add images", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            // There's something wrong with the fields, show error message
        
        }
        
        else
        {
            geoP = GeoPoint(latitude: location!.latitude, longitude: location!.longitude)
            let user = User.getUserData()
            
            Event.addEventObject(user: (user?.uuid)!, coord: geoP, desc: self.perm_desc.text!, images: self.imgArr, time: self.perm_date.date, addy: self.perm_addy.text!, EventUserID: (user?.uuid)!, EventUsername: (user?.name)!,EventUserPhoto: (user?.pfp)!)
            
            let alert = UIAlertController(title: "Event Created", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                let vc = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
//                self.view.window?.rootViewController = vc
//                self.view.window?.makeKeyAndVisible()
//                let VC = MapViewController()
//                                    VC.modalPresentationStyle = .fullScreen
//                                    self.present(VC, animated: true)
//                                    {
                                        self.navigationController?.popToRootViewController(animated: true)
                        
                
//                                    }
//                present(vc!, animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            
            
        }
       
    }
    func validateFields() -> String? {
        
        // Check that all fields are filled in
//        if self.perm_addy.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//            self.perm_desc.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
//            perm_date.state.isEmpty {
//
//            return "Please fill in all fields."
//        }
//
//        if imgArr.count == 0
//        {
//            return "Please choose an image"
//        }
        

        return nil
    }
    

    

    
    
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//
//        (viewController as? Step3ViewController)?.event_desc = perm_desc.text
//        (viewController as? Step3ViewController)?.event_date = perm_date.date
//
//    }
}
extension Step4ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

       let visibleRect = CGRect(origin: slider.contentOffset, size: slider.bounds.size)
       let midPointOfVisibleRect = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
       if let visibleIndexPath = slider.indexPathForItem(at: midPointOfVisibleRect) {
                pageView.currentPage = visibleIndexPath.row
       }
    }
    
}

extension Step4ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left:0, bottom:0, right:0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = slider.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
