//
//  Step3ViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 9/17/22.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation
protocol Step3ViewControllerDelegate: AnyObject
{
    func step3viewcontroller(_ vc: Step3ViewController, description event_desc: String?, add_e event_date: Date)
    
}
class Step3ViewController: UIViewController, SearchViewControllerDelegate, Step4ViewControllerDelegate{
    func step4viewcontroller(_ vc: Step4ViewController, description perm_desc: String?, date_e perm_date: Date) {
        self.event_desc = perm_desc
        self.event_date = perm_date
    }
    
  
    
    var event_date:Date!
    let mapView = MKMapView()
    let panel = FloatingPanelController()
    let pin = MKPointAnnotation()
    var address:String!
    var event_desc:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        mapView.tintColor = .darkGray
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        view.addSubview(mapView)
        let searchVC = SearchViewController()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    func keyboardAppeared(_ vc: SearchViewController)
    {
        panel.move(to: .full, animated: true)
    }
    func keyboardHidden(_ vc: SearchViewController)
    {
        panel.move(to: .half, animated: true)
    }
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?, localeName name: String?)
    {
        guard let coordinates = coordinates else {
            return
        }
        guard name != nil else {
            return
        }
     
     
        panel.move(to: .tip, animated: true)
        mapView.removeAnnotations(mapView.annotations)

        
        pin.coordinate = coordinates
        var mapcoord:CLLocationCoordinate2D = coordinates
        mapcoord.latitude = coordinates.latitude + 0.07
   
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: mapcoord,
                                             span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                                            ), animated: true
                    
        )
    address = name!
     ShowAlert()
        
    }
    func ShowAlert()
    {
        
        let alert = UIAlertController(title: "Confirm Address", message: "Is \(address!) correct?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            self.performSegue(withIdentifier: "3to4", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    func raisePanel()
    {
        panel.move(to: .tip, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
       
                if(segue.identifier == "3to4")
                {
                    if let destination: Step4ViewController = segue.destination as? Step4ViewController
                    {
                        destination.event_addy = address
                        destination.location = self.pin.coordinate
                        destination.event_desc = self.event_desc
                        destination.event_date = self.event_date
                        destination.delegate = self
                        
                    }
                }
    
    }
    
    
}
