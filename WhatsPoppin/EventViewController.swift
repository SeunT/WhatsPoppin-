//
//  EventViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 8/7/21.
//
import UIKit
import MapKit
import CoreLocation
class EventViewController: UIViewController {
  
   
    struct earth: Decodable
    {
        let weatherObservation : weatherObservation
    }
    
    struct weatherObservation: Decodable
    {
        let temperature: String?
        let humidity: Int?
       
        
    }
   
    
    var userid:String!
    var image:String!
    
    @IBOutlet weak var templbl: UILabel!
    @IBOutlet weak var humidlbl: UILabel!
    var disc:String!
    var tim:String!
    var add:String!
    
    var temp:String!
    var hum:String!
    
    var weatherItems:[weatherObservation]?
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var addy: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        templbl.alpha = 0
        humidlbl.alpha = 0
        des.text = disc
        time.text = tim
        addy.text =  add
        img.image = UIImage(named: image)
        displayLoc()
       
        // Do any additional setup after loading the view.
    }
    
    func displayLoc()
    {
       
       
     
        let addressString = add!
       
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
                                            {
                                                [self](placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let lt = placemark.location?.coordinate.latitude
                    let lng = placemark.location?.coordinate.longitude
                 
                    let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = self.add!
                    
                    self.mapView.addAnnotation(ani)
                 //   self.latglb = String(format: "%.2f",lt!)
                   // self.longlb = String(format: "%.2f",lng!)
                  
                    let urlAsString = "http://api.geonames.org/findNearByWeatherJSON?lat="+String(format: "%.2f",lt!)+"&lng="+String(format: "%.2f",lng!)+"&username=ogtalabi"
                    
                    let url = URL(string: urlAsString)!
                   
                    let urlSession = URLSession.shared
                    
                   
                    
                    
                    let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
                        if (error != nil) {
                            print(error!.localizedDescription)
                        }
                        var err: NSError?
                        
                        let decoder = JSONDecoder()
                        let jsonResult = try! decoder.decode(earth.self, from: data!)
                        
                        if (err != nil) {
                            print("JSON Error \(err!.localizedDescription)")
                        }
                        
                        print(jsonResult)
                        
                        DispatchQueue.main.async {
                            self.humidlbl.text = "\(jsonResult.weatherObservation.humidity!) %"
                            self.templbl.text = "\(round(((Double(jsonResult.weatherObservation.temperature!)! * 1.8)+32)*100)/100)°F"
                            self.templbl.alpha = 1
                            self.humidlbl.alpha = 1
                            
                        }

                        
                    })
                    
                    jsonQuery.resume()
                   
                   
                }
                
                
        })
       
        
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
