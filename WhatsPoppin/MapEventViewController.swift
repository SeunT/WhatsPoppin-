//
//  MapEventViewController.swift
//  WhatsPoppin
//
//  Created by Seun Talabi on 12/13/22.
//

import UIKit

class MapEventViewController: UIViewController {
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    var imgArr = [UIImage]()
    @IBOutlet weak var pageView: UIPageControl!
    var eventID:String!
    var Eventt:Events = Events()

    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventTime: UILabel!
  
    var final_event:Event!
    override func viewDidLoad() {
        let group = DispatchGroup()
//        results.forEach { result in
//            group.enter()
//            result.itemProvider.loadObject(ofClass: UIImage.self)
//            { reading, error in
//
//                defer
//                {
//                    group.leave()
//
//                }
//                guard let image = reading as? UIImage, error == nil else{
//                    return
//                }
//
//                self.imgArr.append(image)
//            }
//        }
//        group.enter()
//            Eventt.getEventData(eventID: eventID) {
//                Evnt in
//                self.Eventt.getEventImages(eventID: self.eventID, Evnt: Evnt) {
//                    Evnt2 in
//                    defer
//                                   {
//                                       group.leave()
//
//                                   }
//                    self.final_event = Evnt2
//                }
//            }
 
       // let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        super.viewDidLoad()
        Eventt.getEventData(eventID: eventID) {
            Evnt in
//                defer
//                   {
//                       group.leave()
//
//                   }
            self.eventDesc.text = Evnt.eventdis
            let date = Evnt.eventime!.dateValue()
            //let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            let month = dateFormatter.string(from: date)
            let calendar = Calendar.current
            dateFormatter.dateFormat = "h a"
            let hourAndAmPm = dateFormatter.string(from: date)
            let ampm = dateFormatter.string(from: date)
           // let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            self.eventTime.text = "\(month) \(day) at \(hourAndAmPm)"
           // self.eventTime.text = "\(Evnt.eventime?.seconds)"
            self.Eventt.getEventImages(eventID: self.eventID, Evnt: Evnt) {
                             Evnt2 in
                             self.final_event = Evnt2
                            self.load_images(Evnt2)
                         }
            
        }
   
//        group.notify(queue: .main)
//        {
//            self.eventDesc.text = self.final_event.eventdis!
//            self.final_event.eventimage?.forEach({ data in
//                let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
//                self.imgArr.append(UIImage(data: decoded)!)
//            })
//            self.sliderCollectionView.reloadData()
//            print(self.imgArr.count)
//            self.pageView.numberOfPages = self.imgArr.count
//            self.pageView.currentPage = 0
//
//        }
        // Do any additional setup after loading the view.
    }
    func load_images(_ Events: Event)
    {
            self.imgArr.removeAll()
            Events.eventimage?.forEach({ data in
                
                //    let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
//                    self.imgArr.append(UIImage(data: decoded)!)
                })
                print(imgArr.count)
                pageView.numberOfPages = imgArr.count
                pageView.currentPage = 0
                sliderCollectionView.reloadData()
        
    }
    @IBAction func open_map(_ sender: Any)
    {
//        print(final_event.addy)
//        var addy = final_event.addy!

       
        if let addy = final_event.addy as? String
        {
            addy.replacingOccurrences(of: " ", with: ",", options: .literal, range: nil)
            print(addy)
            let encodedAddress = addy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print(encodedAddress)
            let urlString = "http://maps.apple.com/?address=\(encodedAddress)"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
//            UIApplication.shared.open(NSURL(string: "http://maps.apple.com/?address=\(encodedAddress)")! as URL)
        }
        
//        if let urlString = "http://maps.apple.com/?address=\(addy)" , let url = URL(string: urlString) {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            } else {
//                // handle error: maps app is not installed
//            }
//        } else {
//            // handle error: invalid URL
//        }
//
    }
    
}
extension MapEventViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView{
            vc.image = imgArr[indexPath.row]
        } 
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

       let visibleRect = CGRect(origin: sliderCollectionView.contentOffset, size: sliderCollectionView.bounds.size)
        
       let midPointOfVisibleRect = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
       if let visibleIndexPath = sliderCollectionView.indexPathForItem(at: midPointOfVisibleRect) {
                pageView.currentPage = visibleIndexPath.row
       }
    }
    
}

extension MapEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left:0, bottom:0, right:0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
