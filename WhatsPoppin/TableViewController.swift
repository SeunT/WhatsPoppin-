//
//  TableViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 7/29/21.
//

import UIKit
import MapKit
import CoreLocation
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @IBOutlet weak var Table: UITableView!
    var userid:String!
    @IBOutlet weak var EventTable: UITableView!
    var myEventList:Events =  Events()
    var ppdat:Data!
    var username:String!
    var User:User_info =  User_info()
    var recentdis:String!
    var recenttime:String!
    var recentaddy:String!
    var recentimg:Data!
    let userDefault = UserDefaults.standard
   
    
    override func viewDidLoad()
    {
        
      
        super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
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
            /*
            User.someMethod(completion: {
                success in
                if success {
                    
                }
                else{
                    
                }
            }, lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 20)*/
            User.getEventsNearBy(lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 20, completion: {
                results in
                for result in results
                {
                    let lat = result.data()["lat"] as? Double ?? 0
                    let lng = result.data()["lng"] as? Double ?? 0
                    let address = result.data()["address"] as? String ?? ""
                    print(address)
                }
                print(results)
            })
        }
    }
           
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // calling the model to get the Event count
        var test = self.userDefault.value(forKey: "localEvents")
        return myEventList.getCount()
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.layer.borderWidth = 1.0
            
            // calling the model to get the Event object each row
        let EventItem = myEventList.getEventObject(item:indexPath.row)
            
        cell.eventdis.text = EventItem.eventdis;
        cell.eventTime.text = EventItem.eventime
        
        cell.eventimage.image = UIImage(named: EventItem.eventimage!)
            
            
        return cell
            
    }
        
        // delete table entry
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
        
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
        {
          // delete the data from the Event table,  Do this first, then use method 1 or method 2
            myEventList.removeEventObject(item: indexPath.row)
            
            //Method 1
            self.EventTable.beginUpdates()
            self.EventTable.deleteRows(at: [indexPath], with: .automatic)
            self.EventTable.endUpdates()
            
            //Method 2
              //self.EventTable.reloadData()
            
        }

    
       
        /*
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let selectedIndex: IndexPath = self.EventTable.indexPath(for: sender as! UITableViewCell)!
            let Event = myEventList.Events[selectedIndex.row]
            if(segue.identifier == "detailView"){
                if let viewController: DetailViewController = segue.destination as? DetailViewController {
                    viewController.selectedEvent = Event.EventName;
                    viewController.Eventname2 = Event.EventName;
                    viewController.Eventdes2 = Event.EventDescription;
                    viewController.Eventimmage = Event.EventImageName;
                }
            }
        }*/
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    /*
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            
            if(segue.identifier == "table2profile")
            {
                if let destination: ProfileViewController = segue.destination as? ProfileViewController
                {
                    destination.userid = self.userid
                    destination.username = self.username
                    destination.imagdat = self.ppdat
                    
                    destination.recent_img = self.recentimg
                    destination.recent_tim = self.recenttime
                    destination.recent_addy = self.recentaddy
                    destination.recent_des = self.recentdis
                    
                }
            }
            else if (segue.identifier == "table2event")
            {
                let selectedIndex: IndexPath = self.Table.indexPath(for: sender as! UITableViewCell)!
                let event = myEventList.Events[selectedIndex.row]
              
                
                if let destination: EventViewController = segue.destination as? EventViewController
                {
                    
                    destination.userid = self.userid
                    destination.disc = event.eventdis
                    destination.add = event.addy
                    destination.tim = event.eventime
                    destination.image = event.eventimage
                }
            }
           
        }
     */
        @IBAction func returned(segue: UIStoryboardSegue)
        {
            
            if let sourceView = segue.source as? ProfileViewController
            {
               
                
                
            }
        }
        
        @IBAction func backfromEvent(segue: UIStoryboardSegue)
        {
            
           
        }
            
        


    }
