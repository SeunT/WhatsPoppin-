//
//  EditProfileViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/17/23.
//

import UIKit
struct EditProfileFormModel
{
    let label: String
    let placeholder: String
    var value: String?
}
final class EditProfileViewController: UIViewController, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    private var models =  [[EditProfileFormModel]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))

    }
    private func configureModels()
    {
        //name, website, bio, gender
        let section1Labels = ["Name", "Username", "Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section1.append(model)
        }
        models.append(section1)
        
        let section2Labels = ["Email", "Phone", "Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section2.append(model)
        }
        models.append(section2)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        
    }
    private func createTableHeaderView()-> UIView {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width, height: view.frame.height/4).integral)
        let size = header.frame.height/1.5
        let profilePhoto = UIButton(frame: CGRect(x: (view.frame.width-size)/2,
                                                  y: (header.frame.height-size)/2,
                                                  width: size,
                                                  height: size))
        header.addSubview(profilePhoto)
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius  = size/2.0
        profilePhoto.tintColor = .label
        profilePhoto.addTarget(self, action: #selector(didTapProfilePhotoB), for: .touchUpInside)
        profilePhoto.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return header
    }
    @objc private func didTapProfilePhotoB()
    {
        
    }
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
    @objc private func didTapSave()
    {//save info to database and core data
        dismiss(animated: true, completion: nil)
        
    }
    @objc private func didTapCancel()
    {
        dismiss(animated: true, completion: nil)
        
    }
    @objc private func didTapChangeProfilePicture()
    {
        let actionsheet = UIAlertController(title: "Profile Picture", message: "Change profile picture", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionsheet.popoverPresentationController?.sourceView = view
        actionsheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionsheet, animated: true)
    }
    
//
//    @IBAction func ProfilePic(_ sender: Any)
//    {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        
//        let alerto = UIAlertController(title: "Add Image", message: nil, preferredStyle: .alert)
//        
//        alerto.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                let picker = UIImagePickerController()
//                picker.delegate = self
//                picker.allowsEditing = true
//                picker.sourceType = UIImagePickerController.SourceType.camera
////                picker.cameraCaptureMode = .photo
////                picker.modalPresentationStyle = .fullScreen
//                self.present(picker,animated: true,completion: nil)
//               
//                
//            
//                
//            } else {
//                let alert = UIAlertController(title: "No Camera", message: nil, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//                self.present(alert, animated: true)
//            }
//            
//        }))
//        alerto.addAction(UIAlertAction(title: "library", style: .default, handler: { action in
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            picker.allowsEditing = true
//            picker.sourceType = .photoLibrary
//            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//            picker.modalPresentationStyle = .popover
//            self.present(picker, animated: true, completion: nil)
//                
//               
//            
//           
//            
//        }))
//        alerto.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alerto, animated: true)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
//// Local variable inserted by Swift 4.2 migrator.
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        picker .dismiss(animated: true, completion: nil)
//        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage else {
//                  return
//              }
//        profileImageView.image = selectedImage
//       
//
//        let imageName = NSUUID().uuidString
//        
//        let useruuid = userDefault.string(forKey: "uid")!
//        let storageRef = Storage.storage().reference().child("profiles/\(useruuid)/\(imageName).png")
//        let folderToDelete = Storage.storage().reference().child("profiles/\(useruuid)")
//       
//        let imageData = profileImageView.image!.pngData()
//        let encodedPic = try! PropertyListEncoder().encode(imageData)
//        self.userDefault.setValue(encodedPic, forKey: "profilePic")
//        self.userDefault.synchronize()
//        
//        folderToDelete.listAll { (result, error) in
//            if let error = error {
//              // Handle the error
//            } else {
//                for item in result!.items {
//                item.delete { error in
//                  if let error = error {
//                    // Handle the error
//                  } else {
//                    // File deleted successfully
//                  }
//                }
//              }
//            }
//          }
//        
//        if let uploadData = profileImageView.image!.pngData()
//        {
//            
//            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
//                if let error = err {
//                    print(error)
//                    return
//                }
//                storageRef.downloadURL(completion: { [self] (url, err) in
//                    if let err = err {
//                        print(err)
//                        return
//                    }
//                    
//                    self.User.addPP(user: self.userDefault.string(forKey: "uid")!, image: url!.absoluteString, nm:self.userDefault.string(forKey: "name")!)
//              
//                   
//                })
//            })
//        }
//    }
//    
//   
//
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    // Helper function inserted by Swift 4.2 migrator.
//    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//    }
//
//    // Helper function inserted by Swift 4.2 migrator.
//    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//        return input.rawValue
//    }
//    

}
extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        
        print("Field updated to: \(updatedModel.value ?? "nil")")
    }
}
