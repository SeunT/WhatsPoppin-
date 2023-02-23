//
//  SettingsViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 1/18/23.
//
import SafariServices
import UIKit

struct SettingCellModel {
    let title: String
    let handler: (()-> Void)
}

class SettingsViewController: UIViewController
{
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style:.grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    var User:User_info =  User_info()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configureModels()

        
    }
    private var data = [[SettingCellModel]]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func configureModels()
    {
        data.append([
            SettingCellModel(title: "Edit Profile"){[weak self] in
                self?.editProfileTapped()},
            SettingCellModel(title: "Invite Friends"){[weak self] in
                self?.inviteFriends()},
//            SettingCellModel(title: "Save Original Posts"){[weak self] in
//            self?.logOutButtonTapped()},
        ])
        data.append([
            SettingCellModel(title: "Terms of Service"){[weak self] in
                self?.openURL(type: .terms)},
            SettingCellModel(title: "Privacy Policy"){[weak self] in
                self?.openURL(type: .privacy)},
            SettingCellModel(title: "Help/Feedback"){[weak self] in
                self?.openURL(type: .help)},
        ])
        
        data.append([
            SettingCellModel(title: "Log Out"){[weak self] in
            self?.logOutButtonTapped()},
            SettingCellModel(title: "Delete"){[weak self] in
            self?.deleteAccountButtonTapped()}
        ])
    }
    enum SettingsURLType {
        case terms, privacy, help
    }
    private func openURL(type: SettingsURLType)
    {
        let urlstring: String
        switch type {
        case .terms: urlstring = "https://www.medullalogic.com/whatspoppin-terms-of-service"
        case .privacy: urlstring = "https://www.medullalogic.com/whatspoppin-privacy"
        case .help: urlstring = "https://www.medullalogic.com/whatspoppin"
        }
        
        guard let url = URL(string: urlstring) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    private func inviteFriends ()
    {
        //show share sheet to invite friends
        guard let url = URL(string: "https://apps.apple.com/us/app/whatspoppin/id1664587337") else {
            return
        }
        DispatchQueue.main.async {
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
            self.present(vc, animated: true)
        }
    }
    private func editProfileTapped()
    {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC,animated: true)
        
    }
    @objc func logOutButtonTapped()
    {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive,handler: {_ in
       
            self.User.logoutUser(completion: {success in
                DispatchQueue.main.async {
                if success {
//                    let loginVC = ViewController()
//                    loginVC.modalPresentationStyle = .fullScreen
//                    self.present(loginVC, animated: true)
//                    {
//                        self.navigationController?.popToRootViewController(animated: false)
//                        self.tabBarController?.selectedIndex = 0
//
//                    }
                
//                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "Nav2") as! UINavigationController
//
//                        self.present(vc, animated: true)
//                        {
                            self.tabBarController?.selectedIndex = 0
//                            self.navigationController?.popToViewController(vc, animated: true)
//                            vc.modalPresentationStyle = .fullScreen
//                        }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nav2 = storyboard.instantiateViewController(withIdentifier: "Nav2") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = nav2
                }else {
                    fatalError("Could not log out user")
                    
                }
                }
            })
            //self.storyboard?.instantiateViewController(identifier: "Nav2") as? UINavigationController
        
    //        view.window?.rootViewController = vc
    //        view.window?.makeKeyAndVisible()
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
    }
                                            

    @objc func deleteAccountButtonTapped()
    {
        //add auth deletion
        let actionSheet = UIAlertController(title: "Delete", message: "Are you sure you want to Delete your account?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: {_ in
            //change to        User.deleteUser()
            
          
            self.User.deleteUser_E(completion: {success in
                DispatchQueue.main.async {
                if success {
//                    let loginVC = ViewController()
//                    loginVC.modalPresentationStyle = .fullScreen
//                    self.present(loginVC, animated: true)
//                    {
//                        self.navigationController?.popToRootViewController(animated: false)
//                        self.tabBarController?.selectedIndex = 0
//
//                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nav2 = storyboard.instantiateViewController(withIdentifier: "Nav2") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = nav2
                    self.tabBarController?.selectedIndex = 0
                    
                }else {
                    fatalError("Could not Delete user")
                    
                }
                }
            })
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        present(actionSheet, animated: true)
 
     
    }

}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.section][indexPath.row].handler()
    }
}
