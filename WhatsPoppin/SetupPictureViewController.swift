//
//  SetupPictureViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 7/23/21.
//

import UIKit
import Firebase
class SetupPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilepic: UIImageView!{
        didSet {
            profilepic.layer.borderWidth = 1
               profilepic.layer.masksToBounds = false
            profilepic.layer.borderColor = UIColor.gray.cgColor
               profilepic.layer.cornerRadius = profilepic.frame.height/2
               profilepic.clipsToBounds = true
         }
     }
    
    var User:User_info =  User_info()
    let userDefault = UserDefaults.standard
    var name:String!
    var user_url:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Addpicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alerto = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
        
        alerto.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
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
            self.present(picker, animated: true, completion: nil)
                
               
            
           
            
        }))
        alerto.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alerto, animated: true)
        
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    //    let imageName = NSUUID().uuidString
      // let storageRef = Storage.storage().reference().child("\(imageName).png")
        picker .dismiss(animated: true, completion: nil)
        
        profilepic.image=info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
       
        
        
        
        
        //User.addPP(image: (pp.image?.pngData())!)
        let imageName = NSUUID().uuidString

        let storageRef = Storage.storage().reference().child("Profiles/\(imageName).png") //Load the Firebase storage
        
        if let uploadData = profilepic.image!.pngData()
        {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let error = err {
                    print(error)
                    return
                }
                storageRef.downloadURL(completion: { [self] (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    
                   user_url = url!.absoluteString
                })
            })
        }
    }
    
    @IBAction func done_setup(_ sender: Any)
    {
        if user_url == nil
        {
            let alert = UIAlertController(title: "Please add a picture", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else
        {
            self.User.setup(user: self.userDefault.string(forKey: "UserID")!, image: user_url, nm: self.name)
            
            let controller = self.storyboard?.instantiateViewController(identifier: "Nav2") as? UINavigationController
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
