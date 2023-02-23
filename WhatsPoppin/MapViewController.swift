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
    var promoted:Bool

    init(ID: String, latitude: Double, longitude: Double, promoted: Bool) {
    self.ID = ID
    self.latitude = latitude
    self.longitude = longitude
    self.promoted = promoted
    }
}
class MyAnnotation: MKPointAnnotation {
    var isPromoted: Bool = false
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
    let locationButton: UIButton = {
        let button = UIButton()
        let customColor = UIColor(red: 82/255, green: 10/255, blue: 165/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = customColor
        return button
    }()
 

    var User:User_info =  User_info()
    var userLocation: [CLLocation] = []
    var Event:Events = Events()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(map)
        map.delegate = self
        map.frame = view.bounds
    
        map.addSubview(locationButton)
        configureNavigationBar()
//        map.mapType = .standard
//        map.tintColor = .darkGray
        
//        let geoCoder = CLGeocoder();
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        }
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.leftAnchor.constraint(equalTo: view.leftAnchor),
            map.rightAnchor.constraint(equalTo: view.rightAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            locationButton.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -80),
            locationButton.rightAnchor.constraint(equalTo: map.rightAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 30),
            locationButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)

//
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("RefreshViewController"), object: nil)
        // Do any additional setup after loading the view.
    }
    func getCurrentZoom() -> Double {

           var angleCamera = map.camera.heading
           if angleCamera > 270 {
               angleCamera = 360 - angleCamera
           } else if angleCamera > 90 {
               angleCamera = fabs(angleCamera - 180)
           }

           let angleRad = M_PI * angleCamera / 180

           let width = Double(map.frame.size.width)
           let height = Double(map.frame.size.height)

           let offset : Double = 20 // offset of Windows (StatusBar)
           let spanStraight = width * map.region.span.longitudeDelta / (width * cos(angleRad) + (height - offset) * sin(angleRad))
           return log2(360 * ((width / 256) / spanStraight)) + 1;
         }

    
    @objc func refresh() {
    // update content in the view controller
        EventCache.shared.clearCache()
        map.removeAnnotations(map.annotations)
        renderUserLocation(bool: false)
        
    }
    
    @objc func locationButtonTapped()
    {
        locationButton.setBackgroundImage(UIImage(systemName: "location.fill"), for: .normal)
//        UserDefaults.standard.set(true, forKey: "updateMap")
        renderUserLocation(bool: true)
        
        
    }
   func configureNavigationBar()
    {
    
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setBackgroundImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(continue_next), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
       
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.desiredAccuracy = kCLLocationAccuracyBest //more battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let updateMaptoUserLocation = UserDefaults.standard.bool(forKey: "updateMap")
        if(!updateMaptoUserLocation)
        {
            let latitude = UserDefaults.standard.double(forKey: "map_latitude")
            let longitude = UserDefaults.standard.double(forKey: "map_longitude")
            let latitudeDelta = UserDefaults.standard.double(forKey: "map_latitude_delta")
            let longitudeDelta = UserDefaults.standard.double(forKey: "map_longitude_delta")
            
            if latitude != 0.0 && longitude != 0.0 {
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
                let region = MKCoordinateRegion(center: center, span: span)
                map.setRegion(region, animated: false)
            }
        }
//        else {
            let currentZoom = getCurrentZoom()
    
            if currentZoom <= 7 { // adjust this value as needed
                UserDefaults.standard.set(true, forKey: "updateMap")
                UserDefaults.standard.synchronize()
            }
//        }
        
 
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations
        let updateMaptoUserLocation = UserDefaults.standard.bool(forKey: "updateMap")
        if (!updateMaptoUserLocation)
        {
            // the value is not null
            return
        } else
        {
            UserDefaults.standard.set(false, forKey: "updateMap")
            UserDefaults.standard.synchronize()
            renderUserLocation(bool: true)
            // the value is null
//            if let location = locations.first
//            {
//                manager.stopUpdatingLocation()
//                render(location)
//                /*
//                 User.someMethod(completion: {
//                 success in
//                 if success {
//
//                 }
//                 else{
//
//                 }
//                 }, lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 20)*/
//                Event.getEventsNearBy(lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 50, completion: {
//                    results in
//
//                    var places = [PlacesOnMap(ID: "0", latitude: 0, longitude: 0)]//initialize
//
//                    for result in results
//                    {
//
//                        let lat = result.data()["lat"] as? Double ?? 0
//                        let lng = result.data()["lng"] as? Double ?? 0
//                        let eventID = result.data()["eventID"] as? String ?? ""
//                        //                    let address = result.data()["address"] as? String ?? ""
//                        //                    let loc = CLLocation(latitude: lat, longitude: lng)
//
//                        places.append(PlacesOnMap(ID: eventID, latitude: lat, longitude: lng))
//
//                    }
//                    places.remove(at: 0)//remove first index
//                    let places_res = places.map { placeOnMap -> MKPointAnnotation in
//                        let place = MKPointAnnotation()
//
//                        place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
//                        place.title = placeOnMap.ID
//                        return place
//                    }
//
//                    self.map.addAnnotations(places_res)
//                })
//            }
        }
    }
    
    func renderUserLocation(bool shouldRender:Bool)
    {
        if let location = userLocation.first
        {
            manager.stopUpdatingLocation()
            //decide if you should render again
            //we dont want to render if notification is trigured by event change from other user
            //just create the pins again at the users location
            if(shouldRender)
            {
                render(location)
            }
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
                
                var places = [PlacesOnMap(ID: "0", latitude: 0, longitude: 0, promoted: false)]//initialize
                
                for result in results
                {
                    
                    let lat = result.data()["lat"] as? Double ?? 0
                    let lng = result.data()["lng"] as? Double ?? 0
                    let eventID = result.data()["eventID"] as? String ?? ""
                    let isPromoted = result.data()["isPromoted"] as? Bool ?? false
                    //                    let address = result.data()["address"] as? String ?? ""
                    //                    let loc = CLLocation(latitude: lat, longitude: lng)
                    
                    places.append(PlacesOnMap(ID: eventID, latitude: lat, longitude: lng, promoted: isPromoted))
                    
                }
                places.remove(at: 0)//remove first index
                let places_res = places.map { placeOnMap -> MKPointAnnotation in
//                    let place = MKPointAnnotation()
//
//                    place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
//                    place.title = placeOnMap.ID
//                    place.setValue(placeOnMap.promoted, forKey: "isPromoted")
                    
                 
                    let place = MyAnnotation()
                    place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
                    place.title = placeOnMap.ID
                    place.isPromoted = placeOnMap.promoted
                 
                    return place
                }
                
                self.map.addAnnotations(places_res)
            })
        }
    
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let updateMaptoUserLocation = UserDefaults.standard.bool(forKey: "updateMap")
        
        if(!updateMaptoUserLocation)
        {
            let center = mapView.centerCoordinate
            let span = mapView.region.span
            let currentLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
            Event.getEventsNearBy(lat: center.latitude, long: center.longitude, distance: 50, completion: {
                results in
                
                var places = [PlacesOnMap(ID: "0", latitude: 0, longitude: 0, promoted: false)]//initialize
                
                for result in results
                {
                    
                    let lat = result.data()["lat"] as? Double ?? 0
                    let lng = result.data()["lng"] as? Double ?? 0
                    let eventID = result.data()["eventID"] as? String ?? ""
                    let isPromoted = result.data()["isPromoted"] as? Bool ?? false
                    
                    places.append(PlacesOnMap(ID: eventID, latitude: lat, longitude: lng, promoted: isPromoted))
                    
                }
                places.remove(at: 0)//remove first index
                let places_res = places.map { placeOnMap -> MKPointAnnotation in
//                    let place = MKPointAnnotation()
//
//                    place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
//                    place.title = placeOnMap.ID
//                    place.setValue(placeOnMap.promoted, forKey: "isPromoted")
                    let place = MyAnnotation()
                    place.coordinate =  CLLocationCoordinate2D(latitude: placeOnMap.latitude, longitude: placeOnMap.longitude)
                    place.title = placeOnMap.ID
                    place.isPromoted = placeOnMap.promoted
                    return place
                }
                
                self.map.addAnnotations(places_res)
                
          
            })
            if let userloc = userLocation.first {
                if currentLocation.distance(from: userloc) >= 1 {
                    print("The two locations are not in the same spot")
                    locationButton.setBackgroundImage(UIImage(systemName: "location"), for: .normal)
                }
            }
           
            
            let region = mapView.region
            UserDefaults.standard.set(region.center.latitude, forKey: "map_latitude")
            UserDefaults.standard.set(region.center.longitude, forKey: "map_longitude")
            UserDefaults.standard.set(region.span.latitudeDelta, forKey: "map_latitude_delta")
            UserDefaults.standard.set(region.span.longitudeDelta, forKey: "map_longitude_delta")
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
            
            //use user default instead
            if (UserCache.shared.getUser()?.uuid) != nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let event = storyBoard.instantiateViewController(withIdentifier: "Event") as! EventViewController
                
                event.eventID = annotationTitle!
                navigationController?.pushViewController(event, animated: true);
            }
            else {
                
                let alert = UIAlertController(title: "Login", message: "You need to be logged in to use this feature", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil ))
                self.present(alert, animated: true)
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Attempt to dequeue a reusable annotation view, identified by a unique identifier string.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            
        // If there was no reusable annotation view to dequeue, create a new one.
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
               
            // Specify whether the annotation view is able to show callouts (titles, subtitles, and accessory views) when tapped.
            annotationView?.canShowCallout = false
        } else {
            // If there was a reusable annotation view to dequeue, update its annotation.
            annotationView?.annotation = annotation
        }
            
        // Check if the annotation being added is a custom subclass of MKAnnotation, MyAnnotation.
        if let placeAnnotation = annotation as? MyAnnotation {
            
            // Check the title of the annotation. If it is "user", remove the image from the annotation view.
            if placeAnnotation.title == "user" {
                annotationView?.image = nil
            } else {
                // If the title of the annotation is not "user", the annotation represents a place, and should have a house icon as its image.
                
                
                // Retrieve the value of the isPromoted property from the MyAnnotation object and use it as needed.
                let isPromoted = placeAnnotation.isPromoted
                
                
                if(isPromoted)
                {
                    
                    annotationView?.image = nil
                    //display image for promoted house if it is promoted
                    
                    // Load promoted house image
                    let houseImage = UIImage(named: "premiumHouse")!
                    
                    // Set the desired size of the image
                    let size = CGSize(width: 140, height: 140)
                    
                    // Create a graphics context of the desired size
                    UIGraphicsBeginImageContextWithOptions(size, false, 0)
                    
                    // Draw the image in the graphics context, scaling it to fit the desired size
                    houseImage.draw(in: CGRect(origin: .zero, size: size))
                    
                    // Get the resized image from the graphics context
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    // Clean up the graphics context
                    UIGraphicsEndImageContext()
                    
                    // Set the resized image as the annotation view's image
                    annotationView?.image = resizedImage
                }
                else if(!isPromoted) {
                    
                    
                    
                    // Load the image from the asset catalog
                    let houseImage = UIImage(named: "house")!
                    
                    // Set the desired size of the image
                    let size = CGSize(width: 90, height: 90)
                    
                    // Create a graphics context of the desired size
                    UIGraphicsBeginImageContextWithOptions(size, false, 0)
                    
                    // Draw the image in the graphics context, scaling it to fit the desired size
                    houseImage.draw(in: CGRect(origin: .zero, size: size))
                    
                    // Get the resized image from the graphics context
                    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    // Clean up the graphics context
                    UIGraphicsEndImageContext()
                    
                    // Set the resized image as the annotation view's image
                    annotationView?.image = resizedImage
                }
                
                
                
            }
        }
            
        // Return the completed annotation view to be displayed on the map.
        return annotationView
    }
    

    @objc func continue_next()
    {
        //user userdefaults instead

        if let uuid = UserCache.shared.getUser()?.uuid {
            // use the uuid here
            let vc = NewProfileViewController(currentUser: true, currId: uuid)
//            vc.title = "Profile"
            navigationController?.pushViewController(vc, animated: true)
        } else {
         
            // handle the case where the uuid is nil
            let alert = UIAlertController(title: "Login", message: "You need to be logged in to use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ _ in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil ))
            self.present(alert, animated: true)
            
        }

    }
 

}
