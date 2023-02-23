//
//  ListViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 2/13/23.
//

import UIKit

final class ListViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UserFollowTableViewCell.self,
                           forCellReuseIdentifier: UserFollowTableViewCell.identifier)
        return tableView
    }()

    enum ListType {
        case followers(user: String)
        case following(user: String)

        var title: String {
            switch self {
            case .followers:
                return "Followers"
            case .following:
                return "Following"
            }
        }
    }

    let type: ListType

    private var viewModels: [ListUserTableViewCellViewModel] = []

    // MARK: - Init

    init(type: ListType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        title = type.title
        tableView.delegate = self
        tableView.dataSource = self
        configureViewModels()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func configureViewModels() {
        switch type {
        case .followers(let targetUuid):
            DatabaseManager.shared.followers(for: targetUuid) { [weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserTableViewCellViewModel(imageUrl: nil,  uuid: $0,username:"")
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        case .following(let targetUuid):
            DatabaseManager.shared.following(for: targetUuid) { [weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserTableViewCellViewModel(imageUrl: nil, uuid: $0, username: "")
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserFollowTableViewCell.identifier, for: indexPath) as? UserFollowTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currUserID = (UserCache.shared.getUser()?.uuid)!
        let otherUserID = viewModels[indexPath.row].uuid
        
        if(otherUserID == currUserID)
        {
            let vc = NewProfileViewController(currentUser: true, currId: currUserID)
            navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = NewProfileViewController(currentUser: false, currId: otherUserID)
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


//import UIKit
//
//class ListViewController: UIViewController {
//
////    private let data: [String]
//    private var data = [userRelationship]()
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(UserFollowTableViewCell.self, forCellReuseIdentifier: UserFollowTableViewCell.identifier)
//        return tableView
//    }()
//
//    //MARK: - Init
//    init(data: [userRelationship]) {
//        self.data = data
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.addSubview(tableView)
//
//        view.backgroundColor = .systemBackground
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//
//    }
//}
//extension ListViewController:UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: UserFollowTableViewCell.identifier, for: indexPath) as! UserFollowTableViewCell
////        cell.configure(with: "")
////        cell.textLabel?.text = data[indexPath.row]
////        cell.configure(with: data[indexPath.row])
//        cell.delegate = self
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        //Go to profile of selected cell
//        let model = data[indexPath.row]
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//
//
//}
//extension ListViewController: UserFollowTableViewCellDelegate {
//    func didTapFollowUnfollowButton(model: userRelationship) {
//        switch model.type {
//        case .following:
//            //perform firebase update to unfollow
//            break
//        case .not_following:
//            //perform firebase update to follow
//            break
//        }
//    }
//
//
//}
