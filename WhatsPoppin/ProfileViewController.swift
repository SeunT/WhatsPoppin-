//
//  ProfileViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//
import UIKit
import Firebase
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var pp: UIImageView!
    let db = Firestore.firestore()
    var imagdat:Data!
    var username:String!
    
    var recent_img:Data!
    var recent_addy:String!
    var recent_tim:String!
    var recent_des:String!
    @IBOutlet weak var startlbl: UILabel!
    @IBOutlet weak var deslbl: UILabel!
    @IBOutlet weak var addylbl: UILabel!
    
    @IBOutlet weak var recentimg: UIImageView!
    @IBOutlet weak var recentdes: UILabel!
    @IBOutlet weak var recentaddy: UILabel!
    @IBOutlet weak var recentime: UILabel!
    let userDefault = UserDefaults.standard

    var User:User_info =  User_info()
    @IBOutlet weak var name_label: UILabel!
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func ProfilePic(_ sender: Any)
    {
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
        pp.image=info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
       
        
        let table = self.storyboard?.instantiateViewController(identifier: "TableVC") as? TableViewController
        imagdat = pp.image?.pngData()
        table?.ppdat = imagdat
        
        
        
        //User.addPP(image: (pp.image?.pngData())!)
        let imageName = NSUUID().uuidString

        let storageRef = Storage.storage().reference().child("Profiles/\(imageName).png") //Load the Firebase storage
        
        if let uploadData = pp.image!.pngData()
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
                    
                    self.User.addPP(user: self.userDefault.string(forKey: "UserID")!, image: url!.absoluteString)
                   
                })
            })
        }
    }
    
   
    @IBAction func backFromCreate(segue: UIStoryboardSegue)
    {
       
        
    
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
