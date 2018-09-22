//
//  NasoniViewController.swift
//  Nasoni
//
//  Created by iw on 30/03/2017.
//  Copyright © 2017 iw. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Location: NSObject
{
     var appDelegate =  AppDelegate()
     var annotations = [MKPointAnnotation]()

    func getLocations() -> [MKPointAnnotation]
    {
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        print(appDelegate.locations.count)
        for index in 0...appDelegate.locations.count-1 {
            
            if let name = appDelegate.locations[index]["name"]  {
                
                if let lat = appDelegate.locations[index]["lat"]{
                    
                    if let lon = appDelegate.locations[index]["lon"]{
                        
                        if let latitude = lat as? Double {
                            
                            if let longitude = lon as? Double {
                                
                                let annot1 = MKPointAnnotation()
                                annot1.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                annot1.title = name as? String
                                
                                annotations.append(annot1)
                                
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        return annotations
        
    }

    
}
