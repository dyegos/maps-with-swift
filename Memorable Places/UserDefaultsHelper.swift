//
//  UserDefaultsHelper.swift
//  Memorable Places
//
//  Created by iPicnic Digital on 2/16/16.
//  Copyright © 2016 Dyego Silva. All rights reserved.
//

import Foundation
import CoreLocation

class UserDefaultsHelper
{
    class func saveMyData(arrayOfpalces array: [Place])
    {
        let dict = array.map { ["name" : $0.name, "latitude" : $0.latitude, "longitude" : $0.longitude] }
        
        NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "myPlaces")
    }
    
    class func loadMyData() -> [Place]
    {
        guard let dict = NSUserDefaults.standardUserDefaults().objectForKey("myPlaces") as? [NSDictionary] else
        {
            return [Place]()
        }
        
        return dict.map
        {
            Place(name: $0["name"] as! String, coordinate: CLLocationCoordinate2DMake($0["latitude"] as! Double, $0["longitude"] as! Double))
        }
    }
}