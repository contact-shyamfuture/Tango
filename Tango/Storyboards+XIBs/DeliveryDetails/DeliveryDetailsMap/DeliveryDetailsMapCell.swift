//
//  DeliveryDetailsMapCell.swift
//  Tango
//
//  Created by Shyam Future Tech on 16/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import MapKit

class DeliveryDetailsMapCell: UITableViewCell {
    
    @IBOutlet weak var mapVwdelivery: MKMapView!
    
    var locationManager: CLLocationManager!
    var currentLoc = CLLocationCoordinate2D()
    
    static let identifier = "DeliveryDetailsMapCell"
    static func nib() -> UINib{
        return UINib(nibName: "DeliveryDetailsMapCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.mapVwdelivery.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpdatedLocation(with model : OrderAddress){
       // print(model.latitude,model.longitude)
        if let lat = model.latitude,
            let lang = model.longitude{
            self.upadteLocation(lat: "\(lat)", lang: "\(lang)")
        }
    }
    
}
//Current Location Fetch..
extension DeliveryDetailsMapCell : CLLocationManagerDelegate,MKMapViewDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let locCurrentValue:CLLocationCoordinate2D = location.coordinate
            currentLoc = locCurrentValue
            
            mapVwdelivery.mapType = MKMapType.standard

            let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: locCurrentValue, span: span)
            mapVwdelivery.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = locCurrentValue
            mapVwdelivery.removeAnnotation(annotation)
            mapVwdelivery.addAnnotation(annotation)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        annotationView!.image = UIImage(named: "bike")
        return annotationView
    }
  func upadteLocation(lat : String , lang : String){
        var locValue = CLLocationCoordinate2D()
        let lat: Double = Double("\(lat)")!
        let lon: Double = Double("\(lang)")!
        locValue.latitude = lat
        locValue.longitude = lon
        mapVwdelivery.mapType = MKMapType.standard

        let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapVwdelivery.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        mapVwdelivery.removeAnnotation(annotation)
        mapVwdelivery.addAnnotation(annotation)
        showRouteOnMap(pickupCoordinate: currentLoc, destinationCoordinate: locValue)
    }
    
    // MARK: - showRouteOnMap
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let sourceAnnotation = MKPointAnnotation()

        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }

        let destinationAnnotation = MKPointAnnotation()

        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }

        self.mapVwdelivery.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )

        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile

        // Calculate the direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate {
            (response, error) -> Void in

            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }

                return
            }

            let route = response.routes[0]
            self.mapVwdelivery.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)

            let rect = route.polyline.boundingMapRect
            self.mapVwdelivery.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }

    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .black
        renderer.lineWidth = 3.0
        return renderer
    }

}
