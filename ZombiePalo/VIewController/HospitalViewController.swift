//
//  HospitalViewController.swift
//  ZombiePalo
//
//  Created by Clayton on 20/6/20.
//  Copyright © 2020 Clayton GIlbert. All rights reserved.
//

import UIKit
import MapKit

class HospitalViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var hospitalDistanceLabelTitle: UILabel!
    @IBOutlet weak var hospitalDistanceLabel: UILabel!
    @IBOutlet weak var hospitalWaitingLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedSeverity: Severity!
    var selectedHospital: Hospital!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentLocation()
        
        mapView.delegate = self

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hospitalNameLabel.text = selectedHospital.name
        hospitalDistanceLabel.text = "..."
        
        if let waitTime = selectedHospital.getWaitTime(severity: selectedSeverity) {
            hospitalWaitingLabel.text = Util.shared.displayHourMin(minutes: waitTime)
        }
        locationManager.requestWhenInUseAuthorization()
        
        showHospital()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
        showDistance()
    }
    
    func showHospital(){
        
        if let lat = selectedHospital.lat, let lng = selectedHospital.lng {
            let initialLocation = CLLocation(latitude: lat, longitude: lng)
            mapView.centerToLocation(initialLocation)
        }
    }
    
    func showDistance(){
        if let distance = userDistance(from: selectedHospital) {
            hospitalDistanceLabel.text = Util.distanceToString(distance)
        }else{
            hospitalDistanceLabel.text = "Distance unknown"
        }
    }
    
    private func userDistance(from hospital: Hospital) -> Double? {
        guard let userLocation = mapView.userLocation.location else {
            print("userlocation unknown")
            return nil // User location unknown
        }

        let pointLocation = CLLocation(
            latitude:  hospital.lat!,
            longitude: hospital.lng!
        )
        return userLocation.distance(from: pointLocation)
    }

}
extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1200) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
extension HospitalViewController: CLLocationManagerDelegate {
    
    // MARK - CLLocationManagerDelegate

    func setCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         locationManager.stopUpdatingLocation()
    }
    
   
}
