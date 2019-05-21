//
//  EnterLocationViewController.swift
//  LocationFinderApp
//
//  Created by Atul Bhaisare on 5/20/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import CoreLocation
import TWMessageBarManager
import CoreData

protocol GetNewLocationProtocol : class {
    func sendNewLocation(place : Place)
}

class EnterLocationViewController: BaseViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var enterLocationView: UIView!
    weak var locationProtocolDelegate : GetNewLocationProtocol?
    
    var placesArray :[Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("kLocateAddressVC", comment: "")
        descriptionTextView.placeholder = NSLocalizedString("kDescriptionTxtViewPlaceHolder", comment: "")

        locationTextView.placeholder = NSLocalizedString("kAddressTxtViewPlaceHolder", comment: "")
    }
    
    // MARK: - TextView Validations
    
    func validateTextView() -> Bool {
        guard let _ = descriptionTextView.text else {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: CommonConstants.ErrorMessages.errorTitle, description: CommonConstants.ErrorMessages.descriptionError, type: .error)
            return false
        }
        guard let _ = locationTextView.text else {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: CommonConstants.ErrorMessages.errorTitle, description: CommonConstants.ErrorMessages.addressError, type: .error)
            return false
        }
        
        return true
    }
    // MARK: - IBActions
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if validateTextView() {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(locationTextView.text) { (placemarks, error) in
                guard let placemarks = placemarks,
                      let location = placemarks.first?.location
                    else {
                        // handle no location found
                        TWMessageBarManager.sharedInstance().showMessage(withTitle: CommonConstants.ErrorMessages.errorTitle, description: CommonConstants.ErrorMessages.validAddressError, type: .error)
                        return
                }
                // Use your location
                let place = Place(address: self.locationTextView.text, description: self.descriptionTextView.text, location: location)
                self.saveData(place: place)
                self.locationProtocolDelegate?.sendNewLocation(place: place)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            return
        }
    }
    
    // MARK: - Save CoreData Context
    
    func saveData(place : Place)  {
        let location =  Location(context: CoreDataStack.sharedManager.mainContext)
        location.address = place.address
        location.latitude = place.location.coordinate.latitude
        location.longitude = place.location.coordinate.longitude
        location.locationDescription = place.description
        do{
            try CoreDataStack.sharedManager.mainContext.save()
        }catch{
            print("Error in saving context in save button action: \(error.localizedDescription)")
        }
    }
}

