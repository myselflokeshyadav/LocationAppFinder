//
//  BaseMapViewController.swift
//  RestFunctionlaity
//
//  Created by Atul Bhaisare  on 21/05/19.
//  Copyright © 2019 Atul Bhaisare . All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: BaseViewController {

    @IBOutlet weak var googleMapView: GMSMapView!
    var selectedMarker :GMSMarker?
    var markerInformationWindow : UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        googleMapView.delegate = self
        googleMapView.mapType = .hybrid
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Create Marker
    
    func createMarker( place : Place)  {
        let position = CLLocationCoordinate2DMake(place.location.coordinate.latitude,place.location.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = place.description
        marker.userData = place
        marker.icon = UIImage(named: "markerIcon")
        marker.map = googleMapView
        googleMapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: 18)
    }
}

// MARK: - Create Marker

extension MapViewController : GMSMapViewDelegate {
    // GMSMArker Delegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        selectedMarker = marker
        removeMarkerInformationWindow()
        var infoWindow : UIView!
        if let markerInfo = marker.userData as? Place {
            self.removeMarkerInformationWindow()
            infoWindow = self.noteMarkerView(markerInfo)
            markerInformationWindow  = infoWindow
            
        }
        infoWindow.center = mapView.projection.point(for: marker.position)
        infoWindow.center.y = infoWindow.center.y - 50
        self.view.addSubview(infoWindow)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.removeMarkerInformationWindow()
    }
}

// MARK: - FTMarkerViewDelegate

extension MapViewController : FTMarkerViewDelegate {
    
    func noteMarkerView(_ note : Place) -> UIView {
        let markerView = Bundle.main.loadNibNamed("FTNoteMarkerView", owner: nil, options: nil)![0] as! FTNoteMarkerView
        markerView.delegate = self
        markerView.setup(withItem: note)
        return markerView
    }
    
    func didTapDeleteMarker(_ view: UIView) {
        if (self.markerInformationWindow != nil ) {
            self.markerInformationWindow?.removeFromSuperview()
            self.markerInformationWindow = nil
        }
    }
    
    func removeMarkerInformationWindow() {
        if (self.markerInformationWindow != nil ) {
            self.markerInformationWindow?.removeFromSuperview()
            self.markerInformationWindow = nil
        }
    }
}
