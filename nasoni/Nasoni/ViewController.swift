//
//  ViewController.swift
//  Nasoni
//
//  Created by iw on 30/03/2017.
//  Copyright © 2017 iw. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate

{
    
    var appDelegate =  AppDelegate()

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        UserDefaults.standard.set(appDelegate.locations, forKey: "locations")
        map.reloadInputViews()
        
        map.reloadInputViews()
    
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserDefaults.standard.set(appDelegate.locations, forKey: "locations")
         map.reloadInputViews()
        
         updateLocations()
    }
   
    
    func  updateLocations()
    {
      
        let locationobj = Location()
        let annotations = locationobj.getLocations()
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
        UserDefaults.standard.set(appDelegate.locations, forKey: "locations") // update the locations
        map.reloadInputViews()
        map.delegate = self
        map.reloadInputViews()
    }
    
    
        
    // Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last // didUpdateLocations calls over and over after we call start updating locations , so we are using last to get the most current one
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)// center of the location
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:0.01,longitudeDelta:0.01))// zoom to map
        self.map.setRegion(region, animated:true) // set mapview to go to the region
        self.locationManager.stopUpdatingLocation() // when zoomed in stop updating the location
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors" + error.localizedDescription)
    }
    
   

   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
    }

}
    


