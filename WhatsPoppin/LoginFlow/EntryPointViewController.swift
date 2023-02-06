//
//  EntryPointViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 12/30/22.
//

import UIKit
import CoreData

class EntryPointViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        if (UserDefaults.standard.object(forKey: "uid") != nil)
//        {
//            let vc = self.storyboard?.instantiateViewController(identifier: "Nav3") as? UINavigationController
//            view.window?.rootViewController = vc
//            view.window?.makeKeyAndVisible()
//
//        }else
//        {
//            let vc = self.storyboard?.instantiateViewController(identifier: "Nav2") as? UINavigationController
//            view.window?.rootViewController = vc
//            view.window?.makeKeyAndVisible()
//            present(vc!, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Core_user")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            let count = try context.count(for: request)
            if count == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Nav2") as! UINavigationController
//                {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
//                }
            } else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Nav3") as! UINavigationController
//                {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
//                }
            }
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
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
