//
//  ViewController.swift
//  My_First_MapApp
//
//  Created by Ashok on 7/19/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var ref: FIRDatabaseReference!
    
    var username = "test"
    var i = 0
    var j = 0
    //ref = Database.database().reference()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    private weak var timer: Timer?
    
    //let coordinate = CLLocationCoordinate2DMake(21.283921, -157.831661)
    
    //var x: MKAnnotation? = MKAnnotation(CLLocationCoordinate2DMake(21.283921, -157.831661)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref = FIRDatabase.database().reference()
        
        //self.ref.child("users").child(userid).setValue(["username": username])
        //self.ref.child("users/(user.uid)/username").setValue(username)
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        let art = ArtClass(title: "MyLocation", coordinate: CLLocationCoordinate2DMake(21.283921, -157.831661 ))
        
        //coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661)
        
        mapView.addAnnotation(art)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true){_ in
            self.loadCoordinates()
        }
    }
    
    
    @IBAction func trackChanges(_ sender: Any) {
        
        retrieveData()
        
        
    }
    
    
    func retrieveData(){
        
        //let uid = FIRAuth.auth()?.currentUser?.uid //For authenticating users.
        
        
        self.ref.child("SimulatoriPhone7").observeSingleEvent(of: .value, with: {(snapshot) in
            if let values = snapshot.value as? NSDictionary{
                self.i = 0
                
                for value in values{
                    
                    self.i = self.i+1
                    
                    if let x = values["\(self.i)"]  as? NSDictionary{
                        
                        let lat = x["Lat"] as! Double
                        let lon = x["Lon"] as! Double
                        let time = x["Time"] as! String
                        
                        
                        let coordinate = CLLocationCoordinate2DMake(lat, lon)
                        let art = ArtClass(title: time, coordinate: coordinate)
                        
                        self.mapView.addAnnotation(art)
                        
                        
                        print("\nlat: \(lat), lon: \(lon) and time: \(time)")
                        
                    }
                    
                    print("i value: \(self.i)")
                }
            }else{
                print("unable to unwrap the snapshot value")
            }
            
        })
        
        
    }
    
    func loadCoordinates() {
        
        let temp = locationManager.location?.coordinate
        let time = self.currentTime()
        
        
        j = j+1
        self.ref.child("SimulatoriPhone7").child("\(j)").setValue(["Time": time, "Lat": temp?.latitude, "Lon": temp?.longitude])
        
        //self.ref.child("SimulatoriPhone7").setValue(["Time": time, "Lat": temp?.latitude, "Lon": temp?.longitude])
        
        print("reference value: \(ref)")
        /*
        let art = ArtClass(title: time, coordinate: temp!)
        
        mapView.addAnnotation(art)
        */
        print("time: \(time) coordinates: \(String(describing: temp!))")
        
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(seconds)"
    }
}

