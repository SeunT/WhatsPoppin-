//
//  AddEventViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//


import UIKit
import Firebase
import MapKit
//import CoreLocation
class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var eventima: UIImageView!
    @IBOutlet weak var des: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var addy: UITextField!
    @IBOutlet weak var start_time: UIDatePicker!
    var User:User_info =  User_info()
    let userDefault = UserDefaults.standard
    var url:String!
    var isLoding:Bool!
    var wasCreated:Bool!
    var geoP:GeoPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventima.alpha = 0
        wasCreated = false
        isLoding = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageup(_ sender: Any)
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
        
        isLoding = true
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
    //    let imageName = NSUUID().uuidString
      // let storageRef = Storage.storage().reference().child("\(imageName).png")
        picker .dismiss(animated: true, completion: nil)
        eventima.image=info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage

        
        //User.addPP(image: (pp.image?.pngData())!)
        let imageName = NSUUID().uuidString

        let storageRef = Storage.storage().reference().child("Events/\(imageName).png") //Load the Firebase storage
        
        if let uploadData = eventima.image!.pngData()
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
                    self.eventima.alpha = 1
                    self.url = url!.absoluteString
                    self.isLoding = false
                   
                   
                })
            })
        }
        
    }
    
    @IBAction func create(_ sender: Any)
    {
        let error = validateFields()
        
        
        if error != nil {
            let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            
            // There's something wrong with the fields, show error message
        
        }
        
        else
        {
           
            let addressString = addy.text!
            
            CLGeocoder().geocodeAddressString(addressString, completionHandler:{ [self] (placemarks, error) in
                
                if error != nil
                {
                    let alert = UIAlertController(title: "Invalid Address", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                else
                {
                    if (self.isLoding)
                    {
                        let alert = UIAlertController(title: "Processing the image please wait", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        
                    }
                    else
                    {
                        
                        geoP = GeoPoint(latitude: (placemarks?.first?.location?.coordinate.latitude)!, longitude: (placemarks?.first?.location?.coordinate.longitude)!)
                        
                        User.addEventObject(user: self.userDefault.string(forKey: "UserID")!, coord: geoP, desc: self.des.text!, image: self.url, time: self.start_time.date, addy: self.addy.text!)
                       
                        
                        
                        let alert = UIAlertController(title: "Event was saved!", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        self.wasCreated = true
                        
                    }
                }
            })
            
            
            
        }
            
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if addy.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            des.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            time.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        if url == nil && isLoding == false
        {
            return "Please choose an image"
        }
        
        
        return nil
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
