//
//  Place.swift
//  Memorable Places
//
//  Created by iPicnic Digital on 2/14/16.
//  Copyright © 2016 Dyego Silva. All rights reserved.
//

import UIKit
import CoreLocation

struct Place
{
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(name n:String, coordinate: CLLocationCoordinate2D)
    {
        name = n
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}
