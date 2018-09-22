

import UIKit
import MapKit
import CoreLocation




class NasoniViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate
{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map1: MKMapView!
    var appDelegate =  AppDelegate()


    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //locations.append(["name":"Vatican City","lat":41.902900,"lon":12.453400])
        
        // Do any additional setup after loading the view.
    }
    
    func  updateLocations()
    {
        
        let locationobj = Location()
        let annotations = locationobj.getLocations()
        
        map1.addAnnotations(annotations)
        map1.delegate = self
        map1.reloadInputViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(NasoniViewController.longpress(gestureRecognizer:))) // calls long press method
        uilpgr.minimumPressDuration = 2  // minimum press duration
        map1.addGestureRecognizer(uilpgr) // add gesture recognizer to the map
        
        
        
        
        map1.delegate = self
        
        updateLocations()
    }
    func longpress(gestureRecognizer: UIGestureRecognizer)
    {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began
        {  // check this condition to recognize the gesture only once
            
            print("long press")
            
            let touchPoint = gestureRecognizer.location(in: self.map1)// get locations
            
            let newCoordinate = self.map1.convert(touchPoint, toCoordinateFrom: self.map1) // get coordinates
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude) // convert CLLocationCoordinate2D to CLLocation to pass the coordinate to CLGeocoder()
            
            // get the title by reverse geo coding the address
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)
                in
                if error != nil {
                    print(error)
                }else {
                    if let placemark = placemarks?[0]{
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare! + " "
                            
                        }
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare!
                        }
                        
                    }
                    
                }
                
                if title == ""
                {   // it means title is empty = > something gone wrong ,no address data for the particular location
                    title = "Added \(NSDate()) " // add date if we did not get address for a particular location
                    
                }
                print(newCoordinate)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                
                
                self.map1.addAnnotation(annotation)
              
                self.appDelegate.locations.append(["name":title ,"lat":annotation.coordinate.latitude, "lon":annotation.coordinate.longitude])
                UserDefaults.standard.set(self.appDelegate.locations, forKey: "locations") // update the locations
                self.map1.reloadInputViews()
            })
            
            
            
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last // didUpdateLocations calls over and over after we call start updating locations , so we are using last to get the most current one
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)// center of the location
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01,longitudeDelta:0.01))// zoom to map
        self.map1.setRegion(region, animated:true) // set mapview to go to the region
        self.locationManager.stopUpdatingLocation() // when zoomed in stop updating the location
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors" + error.localizedDescription)
    }
    
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        let selectedAnnotations = self.map1.selectedAnnotations
        for anno : MKAnnotation in selectedAnnotations
        {
            self.map1.removeAnnotation(anno)
        
            print(anno.title!!)
            if (anno.title) != nil
            {
                let speciesPredicate = NSPredicate(format: "name != %@", anno.title!! )
                let filtered = (appDelegate.locations as NSArray).filtered(using: speciesPredicate)
                appDelegate.locations.removeAll()
                appDelegate.locations = filtered as! [Dictionary<String, Any>]
                UserDefaults.standard.set(appDelegate.locations, forKey: "locations") // update the locations                updateLocations()
                map1.reloadInputViews()                
            }

        }
    }
    
   

}
