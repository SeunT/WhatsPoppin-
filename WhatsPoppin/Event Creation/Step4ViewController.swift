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
class Step4ViewController: UIViewController, PHPickerViewControllerDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        }
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var photo1: UIButton!
    @IBOutlet weak var slider: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var create_button: UIButton!
    let userDefault = UserDefaults.standard
    weak var delegate: Step4ViewControllerDelegate?
    var User:User_info =  User_info()
    var Event:Events = Events()
    var location : CLLocationCoordinate2D?
    @IBOutlet weak var perm_date: UIDatePicker!
    @IBOutlet weak var perm_desc: UITextView!
    @IBOutlet weak var perm_addy: UILabel!
    var geoP:GeoPoint!
    var event_desc:String!
    var event_date:Date!
    var event_addy:String!
    var imgArr = [UIImage]()
    @IBOutlet weak var going: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        perm_date.date = event_date
        perm_addy.text = event_addy
        perm_desc.text = event_desc
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        configure_constraints()
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
    func configure_constraints()
    {
        
        slider.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
              slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              slider.widthAnchor.constraint(equalTo: view.widthAnchor),
              slider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
          ])
        photo1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photo1.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 0),
            photo1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            photo1.widthAnchor.constraint(equalToConstant: 50),
            photo1.heightAnchor.constraint(equalToConstant: 50)
        ])
     
        // Add constraints for time label
        time.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            time.topAnchor.constraint(equalTo: photo1.bottomAnchor, constant: 5),
        ])

        // Add constraints for perm_date
        perm_date.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            perm_date.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            perm_date.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 5),
            perm_date.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        ])
     

        // Add constraints for address label
        address.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            address.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            address.topAnchor.constraint(equalTo: perm_date.bottomAnchor, constant: 5),
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
            desc.topAnchor.constraint(equalTo: perm_addy.bottomAnchor, constant: 10),
            desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        // Add constraints for perm_desc
          perm_desc.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              perm_desc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              perm_desc.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 5),
              perm_desc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              perm_desc.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
          ])
          //Add constraints for create_button
          create_button.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              create_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              create_button.topAnchor.constraint(equalTo: perm_desc.bottomAnchor, constant: 10),
              create_button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              create_button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
          ])
      
      }
    
    
    @IBAction func Photo1(_ sender: Any) {
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

    @IBAction func createEvent(_ sender: Any)
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
            Event.addEventObject(user: self.userDefault.string(forKey: "uid")!, coord: geoP, desc: self.perm_desc.text!, images: self.imgArr, time: self.perm_date.date, addy: self.perm_addy.text!)
            
            let alert = UIAlertController(title: "Event Created", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                let vc = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
                self.view.window?.rootViewController = vc
                self.view.window?.makeKeyAndVisible()
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
