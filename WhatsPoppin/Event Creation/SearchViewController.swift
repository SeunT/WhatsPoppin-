//
//  SearchViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/18/22.
//

import UIKit
import CoreLocation
import FloatingPanel
protocol SearchViewControllerDelegate: AnyObject
{
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?, localeName name: String?)
    func keyboardAppeared(_ vc: SearchViewController)
    func keyboardHidden(_ vc: SearchViewController)
    
}

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    

    
    weak var delegate: SearchViewControllerDelegate?
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Whats Poppin?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()

    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Address"
        field.layer.cornerRadius = 9
        field.backgroundColor = .tertiarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y:0, width: 10, height:60))
        field.leftViewMode = .always
        return field
        
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(field)
        view.addSubview(tableView)
        tableView.backgroundColor = .secondarySystemBackground
        field.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 20, width: label.frame.size.width, height: label.frame.size.height)
        field.frame = CGRect(x: 10, y: 30+label.frame.size.height, width: view.frame.size.width-20, height: 50)
        let tableY: CGFloat = field.frame.origin.y+field.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
        
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        delegate?.keyboardAppeared(self)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.keyboardHidden(self)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty
        {
            LocationManager.shared.findLocations(with: text) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coordinate = locations[indexPath.row].coordinates
        let location_name = locations[indexPath.row].title
        delegate?.searchViewController(self, didSelectLocationWith: coordinate, localeName: location_name)
        //notify map controller to show pin
    }
   
}
