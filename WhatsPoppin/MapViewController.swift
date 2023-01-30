//
//  MapViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/4/22.
//

import UIKit
import MapKit
import CoreLocation
struct PlacesOnMap {
    var ID: String
    var latitude: Double
    var longitude: Double

init(ID: String, latitude: Double, longitude: Double) {
    self.ID = ID
    self.latitude = latitude
    self.longitude = longitude
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    let manager = CLLocationManager()
//    @IBOutlet weak var map:MKMapView!
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
        
    }()
    let map:MKMapView = {
        let Map = MKMapView()
        Map.mapType = .standard
        Map.tintColor = .darkGray
        Map.translatesAutoresizingMaskIntoConstraints = false
        return Map
    }()
    var User:User_info =  User_info()
    var Event:Events = Events()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        map.delegate = self
        map.frame = view.bounds
        configureNavigationBar()
//        map.mapType = .standard
//        map.tintColor = .darkGray
        let geoCoder = CLGeocoder();
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
         
        

        // Do any additional setup after loading the view.
    }
   func configureNavigationBar()
    {
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .done, target: self, action: #selector(continue_next))
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        manager.desiredAccuracy = kCLLocationAccuracyBest //more battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first
        {
            manager.stopUpdatingLocation()
            render(location)
            /*
            User.someMethod(completion: {
                success in
                if success {
                    
                }
                else{
                    
                }
            }, lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 20)*/
            Event.getEventsNearBy(lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 50, completion: {
                results in
//                let places =  { result -> results in
//                    let lat = result.data()["lat"] as? Double ?? 0
//                    let lng = result.data()["lng"] as? Double ?? 0
//                    let place = MKPointAnnotation()
//                    place.coordinate =  CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                    place.setValue(result.data()["eventID"] as? String ?? "", forKey: "eventID")
//                    print(place.value(forKey: "eventID")!)
//                    return place
//                }
//                var res = results
//
//                var lat_1 = res.remove(at: 0).data()["lat"] as? Double ?? 0
//                var lng_1 = res.remove(at: 0).data()["lng"] as? Double ?? 0
//                var ID_1 = res.remove(at: 0).data()["eventID"] as? String ?? ""
                var places = [PlacesOnMap(ID: "0", latitude: 0, longitude: 0)]//initialize
                
                for result in results
                {
                
                    let lat = result.data()["lat"] as? Double ?? 0
                    let lng = result.data()["lng"] as? Double ?? 0
                    let eventID = result.data()["eventID"] as? String ?? ""
//                    let address = result.data()["address"] as? String ?? ""
//                    let loc = CLLocation(latitude: lat, longitude: lng)
                    
                    places.append(PlacesOnMap(ID: eventID, latitude: lat, longitude: lng))
                
                }
                places.remove(at: 0)//remove first index
                let places_res = places.map { placeOnMap -> MKPointAnnotation in
                        let place = MKPointAnnotation()
                    
                        place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
                        place.title = placeOnMap.ID
                        return place
                    }
                
                self.map.addAnnotations(places_res)
            })
        }
    }

    func render(_ location: CLLocation)
    {
        let coord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let regin = MKCoordinateRegion(center: coord, span: span)
        
        map.setRegion(regin, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coord
        pin.title = "user"
        
        map.addAnnotation(pin)
    
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
             guard let annotationTitle = view.annotation?.title else
                   {
                       print("Unable to retrieve details")
                    return
                   }
          print("User tapped on annotation with title: \(annotationTitle!)")

        if(!(annotationTitle! == "user"))
            {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let event = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventViewController
        
                    event.eventID = annotationTitle!
                    navigationController?.pushViewController(event, animated: true);
            }
        
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        

        
//        // create a unique identifier for pin reuse
//        let identifier = "Placemark"
//
//        // see if there already is a created pin
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
        if annotationView == nil {
            // there wasn't a pin, so we make a new one


            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            // this is where your title is allowed to be shown when tapping the pin
            annotationView?.canShowCallout = false

            // this gives you an information button in the callout if needed
            // if you use the rightCalloutAccessoryView you must implement:
            // func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            // we have an old annotation, so update it
            annotationView?.annotation = annotation
        }
        if (annotation.title! == "user")
        {
        //    annotationView?.image = UIImage(named: "userimg")
      
        }
        else
        {
            annotationView?.image = UIImage(named: "house")
            
        }
        return annotationView
    }
    

    @objc func continue_next()
    {

   
        let vc = NewProfileViewController(currentUser: true, currId:(UserCache.shared.getUser()?.uuid)!)
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)

    }
 

}
