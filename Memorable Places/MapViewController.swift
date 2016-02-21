//
//  ViewController.swift
//  Memorable Places
//
//  Created by iPicnic Digital on 2/14/16.
//  Copyright © 2016 Dyego Silva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var placesArray:[Place]?
    var place:Place?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.aksUserForLocationPermission()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Pin Gesture
    
    func setUpMapViewGesture()
    {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "action:")
        longPressGesture.minimumPressDuration = 1
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    func action(gestureReconizer: UIGestureRecognizer)
    {
        if gestureReconizer.state == .Began
        {
            let touchPoint = gestureReconizer.locationInView(self.mapView)
            
            let newCoodinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            searchReverseGeocodeLocation(CLLocation(latitude: newCoodinate.latitude, longitude: newCoodinate.longitude))
        }
    }
    
    //MARK: Reverse Geocode Location
    
    func searchReverseGeocodeLocation(location: CLLocation)
    {
        CLGeocoder().reverseGeocodeLocation(location)
        { (placeMarks, error) -> Void in
            
            var fullThoroughFare = (thoroughfare: "", subThoroughfare: "")
            
            if error != nil
            {
                print("Deu erro aqui mano: \(error!.code)")
                return
            }
            else if let p = placeMarks?[0]
            {
                if let t = p.thoroughfare { fullThoroughFare.thoroughfare = "\(t)" }
                if let st = p.subThoroughfare { fullThoroughFare.subThoroughfare = "\(st)" }
                
                //print("placeMark: \(p.thoroughfare)")
                //print("placeMark: \(p.subThoroughfare)")
            }
            
            //Cria a string completa do nome da via e verfica se está tudo nulo e coloca uma valor qualquer
            var fullString = fullThoroughFare.thoroughfare + " " + fullThoroughFare.subThoroughfare
            if fullString == " " { fullString = "\(NSDate())" }
            
            //adiciona o local no array de locais
            self.placesArray!.append(Place(name: fullString, coordinate: location.coordinate))
            UserDefaultsHelper.saveMyData(arrayOfpalces: self.placesArray!)
            
            //print("places count, \(places.count)")
            
            dispatch_async(dispatch_get_main_queue())
            {
                self.mapView.addAnnotation(self.createAnotation(location.coordinate, title: fullString, subTitle: nil))
            }
        }
    }
    
    //MARK: Anotation
    
    func createAnotation(coordinate: CLLocationCoordinate2D, title: String, subTitle: String?) -> MKPointAnnotation
    {
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = coordinate
        anotation.title = title
        anotation.subtitle = subTitle
        
        return anotation
    }

    //MARK: Request Permision
    
    func aksUserForLocationPermission()
    {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let p = place
        {
            findLocation(CLLocation(latitude: p.latitude, longitude: p.longitude))
            self.mapView.addAnnotation(self.createAnotation(CLLocationCoordinate2DMake(p.latitude, p.longitude), title: p.name, subTitle: nil))
            self.navigationItem.title = p.name
        }
        else if let _ = placesArray
        {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.setUpMapViewGesture()
            self.navigationItem.title = "Save a place"
        }
        
    }
    
    func findLocation(userLocation: CLLocation)
    {
        let coordinates = (latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let deltaSpan = (latitudeDelta: 0.01, longitudeDelta: 0.01)
        let span = MKCoordinateSpanMake(deltaSpan.latitudeDelta, deltaSpan.longitudeDelta)
        
        let userCoordinates = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude)
        let region = MKCoordinateRegionMake(userCoordinates, span)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    //MARK: Location Delegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        findLocation(locations[0])
    }
}

