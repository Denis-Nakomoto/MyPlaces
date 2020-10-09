//
//  MapViewController.swift
//  My Places
//
//  Created by Smart Cash on 08.07.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getPlaceAddress (_ address: String?)
}

class MapViewController: UIViewController {

    @IBOutlet var centerPin: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var doneButton: UIButton!
    
    var mapViewController: MapViewControllerDelegate?
    let locationManager = CLLocationManager()
    var place = Places()
    let annottaionIdentifier = "annottaionIdentifier"
    var incomingSegueIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addressLabel.text = ""
        setupMapView()
        checkLocationServices()
    }
    
    @IBAction func centerUserLocation() {
        showUserLocation()
    }
    
    @IBAction func cancel() {
        dismiss(animated: true)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        mapViewController?.getPlaceAddress(addressLabel.text)
        dismiss(animated: true)
    }
    
    private func showUserLocation (){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 10000,
                                            longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthirisation()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.allertController(title: "Location services is disabled", message: "To enable the service go to Settings -> Privacy -> turn it On")
            }
            
        }
        
    }
    
    private func getCenterLocation (for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func allertController (title: String, message: String) {
        let allertController = UIAlertController(title: title,
                                                 message: message,
                                                 preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        allertController.addAction(cancelAction)
        present(allertController, animated: true)
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func checkLocationAuthirisation (){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            if incomingSegueIdentifier == "showAddres" { showUserLocation() }
            mapView.showsUserLocation = true
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.allertController(title: "Access to your location is denied", message: "To enable the service go to Settings -> Privacy -> turn it On")
            }
            break
        case .restricted:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.allertController(title: "Access to your location is restricted", message: "To allow full acccess go to Settings -> Privacy -> turn it On")
            }
            break
        @unknown default:
            print ("New ase is available")
        }
    }
    private func setupMapView () {
        if incomingSegueIdentifier == "showPlace"{
            setupPlacemark()
            addressLabel.isHidden = true
            centerPin.isHidden = true
            doneButton.isHidden = true
        }
    }
    private func setupPlacemark () {
        guard let location = place.location else {return}
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            guard let placeLocation = placemark?.location else {return}
            annotation.coordinate = placeLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annottaionIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView (annotation: annotation, reuseIdentifier: annottaionIdentifier)
            annotationView?.canShowCallout = true
        }
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            if let error = error {
                print (error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildName = placemark?.subThoroughfare
            DispatchQueue.main.async {
                if streetName != nil && buildName != nil {
                    self.addressLabel.text = "\(streetName!), \(buildName!)"
                } else if streetName != nil {
                    self.addressLabel.text = "\(streetName!)"
                } else {
                    self.addressLabel.text = ""
                }
            }
        }
        
    }
}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthirisation()
    }
    
}
