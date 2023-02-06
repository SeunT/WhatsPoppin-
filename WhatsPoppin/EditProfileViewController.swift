//
//  EditProfileViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/17/23.
//

import UIKit
import FirebaseStorage
import SDWebImage
import CoreData
struct EditProfileFormModel
{
    let label: String
    let placeholder: String
    var value: String?
}
protocol ReloadDelegate {
    func reloadData()
}
final class EditProfileViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
 
    var delegate: ReloadDelegate?
    var User:User_info =  User_info()
    let userDefault = UserDefaults.standard
    var profileImagDat:Data?
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    
    private var profilePhoto:UIButton =
    {
        let button = UIButton()
        return button
    }()
    var name_error:Bool!
    private var models =  [[EditProfileFormModel]]()
    private var updatemodel = [EditProfileFormModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        let rightbutton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        rightbutton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: customColor], for: .normal)
        let leftbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        leftbutton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: customColor], for: .normal)
        navigationItem.rightBarButtonItem = rightbutton
        navigationItem.leftBarButtonItem = leftbutton
        setUpDismissKeyboardGesture()
        name_error = false

    }
    private func setUpDismissKeyboardGesture() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
           self.view.addGestureRecognizer(tapGesture)
       }

       @objc func dismissKeyboard() {
           self.view.endEditing(true)
       }
    private func configureModels()
    {
        //grab data 
        //name, website, bio, gender
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
                let users = try context.fetch(fetchRequest) as! [Core_user]
                    
                let section1Labels = ["name","bio"]
                var section1 = [EditProfileFormModel]()
                for label in section1Labels {
                    if label == "name"
                    {
                        let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: users.first?.name!)
                        section1.append(model)
                    }
                    else
                    {
                        let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: users.first?.bio ?? nil)
                        section1.append(model)
                    }
               
                }
                models.append(section1)
            
        //     email, phone, gender
                 let section2Labels = ["email", "gender"]
                 var section2 = [EditProfileFormModel]()
                 for label in section2Labels {
                     if label == "email"
                     {
                         let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: users.first?.email ?? nil)
                         section2.append(model)
                     }
                     else
                     {
                         let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: users.first?.gender ?? nil)
                         section2.append(model)
                     }
                 }
                 models.append(section2)
        }
        catch
        {
            print("Error grabbing uuid \(error)")
            
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        
    }
    private func createTableHeaderView()-> UIView {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
          let header = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: view.frame.width, height: view.frame.height/4).integral)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
            let url = URL(string: (users.first?.pfp!)!)
    
            let size = header.frame.height/1.5
            profilePhoto = UIButton(frame: CGRect(x: (view.frame.width-size)/2,
                                                      y: (header.frame.height-size)/2,
                                                      width: size,
                                                      height: size))
            header.addSubview(profilePhoto)
            profilePhoto.layer.masksToBounds = true
            profilePhoto.layer.cornerRadius  = size/2.0
            profilePhoto.tintColor = .label
            profilePhoto.addTarget(self, action: #selector(didTapChangeProfilePicture), for: .touchUpInside)
          
            profilePhoto.sd_setBackgroundImage(with: url, for: .normal)
//            profilePhoto.setBackgroundImage(profileImageIntial, for: .normal)
            profilePhoto.layer.borderWidth = 1
            profilePhoto.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        }
        catch{
            print("error getting url \(error)")
    
            
        }
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
     
        let global = DispatchGroup()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        do {
            let users = try context.fetch(fetchRequest) as! [Core_user]
            
    
            let useruuid = (users.first?.uuid!)!

            for section in 0..<tableView.numberOfSections {
                    for row in 0..<tableView.numberOfRows(inSection: section) {
                        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? FormTableViewCell {
                            cell.saveButtonTapped()
                        }
                    }
                }
            
 
            if(name_error)
            {
                print("display error")
                let alert = UIAlertController(title: "You must have a name", message: "Please provide a name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true)
                return
            }
            else
            {
                print(updatemodel)
                User.updateUser(uid: useruuid, model: updatemodel)
            }
            
            if(profileImagDat != nil)
            {
                global.enter()
                
                
                let imageName = NSUUID().uuidString
                
                
                
                let storageRef = Storage.storage().reference().child("profiles/\(useruuid)/\(imageName).png")
                let folderToDelete = Storage.storage().reference().child("profiles/\(useruuid)")
                
                let group = DispatchGroup()
                var count = 0
                group.enter()
                folderToDelete.listAll { (result, error) in
                    if let error = error {
                        // Handle the error
                        print("error getting list of images \(error)")
                    } else {
                        
                        
                        
                        for item in result!.items {
                            item.delete { error in
                                if let error = error {
                                    // Handle the error
                                    print("error deleting from db \(error)")
                                } else
                                {
                                    count+=1
                                    // File deleted successfully
                                    if(count == result!.items.count)
                                    {
                                        group.leave()
                                    }
                                }
                            }
                            
                        }
                        if(result!.items.count == 0)
                        {
                            group.leave()
                        }
                        
                       
                    }
                }
//
//                if let uploadData = profileImagDat
//                {
                    
//                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
//                        if let error = err {
//                            print(error)
//                            return
//                        }
//                        storageRef.downloadURL(completion: { [self] (url, err) in
//                            if let err = err {
//                                print(err)
//                                return
//                            }
                            
                       
                group.notify(queue: .main)
                {
                    self.User.addPP(user: useruuid, dat:self.profileImagDat)
                    {
                        _ in
                        global.leave()
                    }
                }
                            
//
//                        })
//                    })
//                }
            }
        }
        catch
        {
            print("Error grabbing uuid \(error)")
            
            
        }
        
        global.notify(queue: .main)
        {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.reloadData()
        }

        
    }
    @objc private func didTapCancel()
    {
        dismiss(animated: true, completion: nil)
        
    }
    @objc private func didTapChangeProfilePicture()
    {
        let actionsheet = UIAlertController(title: "Profile Picture", message: "Change profile picture", preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.delegate = self
        
        actionsheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
          
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = UIImagePickerController.SourceType.camera
//                picker.cameraCaptureMode = .photo
//                picker.modalPresentationStyle = .fullScreen
                self.present(picker,animated: true,completion: nil)




            } else {
                let alert = UIAlertController(title: "No Camera", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true, completion: nil)

            
        }))
        
   
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionsheet.popoverPresentationController?.sourceView = view
        actionsheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionsheet, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        picker .dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage else {
                  return
              }
        profilePhoto.setBackgroundImage(selectedImage, for: .normal)
        profileImagDat = selectedImage.pngData()
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
extension EditProfileViewController: FormTableViewCellDelegate {
    
    
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        
        if(updatedModel.label == "name" && (updatedModel.value?.trimmingCharacters(in: .whitespaces) == ""))
        {
                // Value is empty
                name_error = true
            
            
        }
        else {
            updatemodel.append(updatedModel)
            print(updatedModel.label)
            print("Field updated to: \(updatedModel.value ?? "nil")")
        }

        //update firebase and core data
    }
}
