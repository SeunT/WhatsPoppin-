//
//  SetupPictureViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 7/23/21.
//

import UIKit
import Firebase
import CoreData
class SetupPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let continue_next: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONTINUE", for: .normal)
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.addTarget(self, action: #selector(continue_Tapped), for: .touchUpInside)
        button.setTitleColor(customColor, for: .normal) 
        return button
    }()
    let addpp: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.addTarget(self, action: #selector(addpp_Tapped), for: .touchUpInside)
        button.tintColor = customColor
        return button
    }()
    let  profilepic: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = true
            imageView.layer.borderColor = UIColor.gray.cgColor
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.borderWidth = 2
            return imageView
        }()
    let activitySpinner: UIActivityIndicatorView = {
            let activitySpinner = UIActivityIndicatorView(style: .medium)
            activitySpinner.translatesAutoresizingMaskIntoConstraints = false
            activitySpinner.hidesWhenStopped = true
            let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
            activitySpinner.color = customColor
            return activitySpinner
        }()
    var User:User_info =  User_info()
    var name:String!
    var user_url:String!
    var imagdat:Data!
    var useruuid:String!
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure_const()
        
     
        if let uuid = userDefault.object(forKey: "uuid") as? String
        {
            // use the uuid here
            useruuid = uuid
        }
           
        
      
    }
    
    func configure_const()
    {
        view.addSubview(profilepic)
        view.addSubview(addpp)
        view.addSubview(continue_next)
        view.addSubview(activitySpinner)
            NSLayoutConstraint.activate([
                profilepic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                profilepic.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                profilepic.heightAnchor.constraint(equalToConstant: 100)
            ])
     
            NSLayoutConstraint.activate([
                addpp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
                addpp.topAnchor.constraint(equalTo: profilepic.bottomAnchor, constant: 90),
                addpp.heightAnchor.constraint(equalToConstant: 20)
            ])
            
        
            NSLayoutConstraint.activate([
                continue_next.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                continue_next.topAnchor.constraint(equalTo: profilepic.bottomAnchor, constant: 250)
            ])
        // Add constraints for activity spinner
        NSLayoutConstraint.activate([
            activitySpinner.topAnchor.constraint(equalTo: profilepic.topAnchor,constant: 150),
            activitySpinner.bottomAnchor.constraint(equalTo: profilepic.bottomAnchor),
            activitySpinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activitySpinner.centerXAnchor.constraint(equalTo: profilepic.centerXAnchor),
                activitySpinner.centerYAnchor.constraint(equalTo: profilepic.centerYAnchor),
            activitySpinner.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])



      
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.frame = view.bounds
        let size = scrollView.frame.width/2
        profilepic.frame = CGRect(x: (scrollView.frame.width-size)/2,
                                  y: 100,
                                  width: size,
                                  height: size)
        profilepic.layer.cornerRadius = profilepic.frame.width/2.0


    }
    
    @objc func addpp_Tapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alerto = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
        
        alerto.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker,animated: true,completion: nil)
               
                
            
                
            } else {
                let alert = UIAlertController(title: "No Camera", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
        }))
        alerto.addAction(UIAlertAction(title: "library", style: .default, handler: { action in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
                
               
            
           
            
        }))
        alerto.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alerto, animated: true)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let group = DispatchGroup()
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        picker .dismiss(animated: true, completion: nil)

        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage else {
                  return
              }

        guard let imageData = selectedImage.pngData() else { return }
        imagdat = imageData
        profilepic.image = selectedImage

        let imageName = NSUUID().uuidString

        let storageRef = Storage.storage().reference().child("profiles/\(useruuid!)/\(imageName).png") //Load the Firebase storage

        if let uploadData = profilepic.image!.pngData()
        {
            group.enter()
            disableViews()
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let error = err {
                    print(error)
                    return
                }
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    self.user_url = url?.absoluteString
                    group.leave()
                })
            })
        }
        group.notify(queue: .main)
        {
            self.enableViews()
        }
    }
    func disableViews()
    {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        addpp.alpha = 0.5
        addpp.isUserInteractionEnabled = false
        addpp.isEnabled = false
        profilepic.alpha = 0.5
        continue_next.alpha = 0.5
        continue_next.isUserInteractionEnabled = false
        continue_next.isEnabled = false
    }
    
    func enableViews()
    {
        addpp.alpha = 1
        addpp.isUserInteractionEnabled = true
        addpp.isEnabled = true
        activitySpinner.isHidden = true
        activitySpinner.stopAnimating()
        profilepic.alpha = 1
        continue_next.alpha = 1
        continue_next.isUserInteractionEnabled = true
        continue_next.isEnabled = true
    
    }

    @objc func continue_Tapped()
    {
        if imagdat == nil
        {
            let alert = UIAlertController(title: "Please add a picture", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }else
        {
                self.User.setup(user: useruuid, image: user_url, nm: self.name, pfp: imagdat)
                
                let controller = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
                self.view.window?.rootViewController = controller
                self.view.window?.makeKeyAndVisible()
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

}
