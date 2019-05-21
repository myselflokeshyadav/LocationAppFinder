//
//  GMapViewController.swift
//  LocationFinderApp
//
//  Created by Atul Bhaisare on 5/20/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import CoreLocation
import TWMessageBarManager
import GoogleMaps
import MessageUI

class GMapViewController: MapViewController{

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationTextView: UITextView!
    var placesArray :[Place] = []
    var selectedLocation : Place?
    var showAllLocationFlag : Bool = false
    let textMessageRecipients = ["1-800-867-5309"]

    @IBOutlet weak var enterLocationView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if showAllLocationFlag {
            self.showAllLocations()
        }
        else {
            self.showSelectedLocation()
        }
    }
    // MARK: - View lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Show all saved Locations
    
    func showAllLocations()  {
        for place in placesArray {
            self.createMarker(place:place)
        }
    }
    
    // MARK: - Show selected location
    
    func showSelectedLocation()  {
        guard let selectedLocation = selectedLocation else {
            return
        }
        self.createMarker(place: selectedLocation)
    }
   
    
    // MARK: - IBActions
    
    @IBAction func shareBtnAction(_ sender: Any) {
        guard let position =  selectedMarker?.position else {
            TWMessageBarManager.sharedInstance().showMessage(withTitle: "Alert", description: "Please select any location", type: .error)
        
            return
            
        }
        let stringPoint  = String(format: "%f, %f",position.latitude,position.longitude)
        
        let alertController = UIAlertController(title: NSLocalizedString("kShareAlertTitle", comment: ""), message: NSLocalizedString("kShareAlertMessage", comment: ""), preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: NSLocalizedString("kShareViaEmail", comment: ""), style: .default) { (action:UIAlertAction) in
            let mailComposeViewController = self.configuredMailComposeViewController(message: stringPoint)
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                        } else {
                            self.showSendMailErrorAlert()
                    }

        }
        
        let action2 = UIAlertAction(title: NSLocalizedString("kShareViaMessage", comment: ""), style: .default) { (action:UIAlertAction) in
             self.messageCompose(message: stringPoint)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("kCancel", comment: ""), style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            print("Yes")
        })
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(cancel)

    
        self.present(alertController, animated: true, completion: nil)
        }
}

// MARK: - MFMailComposerDelegate

extension GMapViewController : MFMailComposeViewControllerDelegate {
    // MARK: - MFMailComposer
    
    func configuredMailComposeViewController(message : String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Location Coordinate")
        mailComposerVC.setMessageBody(message, isHTML: false)
        return mailComposerVC
    }

    // MARK: - MFMailComposerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func showSendMailErrorAlert() {
        TWMessageBarManager.sharedInstance().showMessage(withTitle: "Could Not Send Email", description: "Your device could not send e-mail.  Please check e-mail configuration and try again.", type: .error)
    }
}

extension GMapViewController : MFMessageComposeViewControllerDelegate {
    
    // MARK: - MessageComposer
    
    func configuredMessageComposeViewController(message :String)  {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        guard let address = selectedLocation?.address else {
            return
        }
        messageComposeVC.body = "Hey friend - Just sending a location \(address)!"
        present(messageComposeVC, animated: true, completion: nil)
    }
    // MARK: - MessageComposerDelegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func messageCompose(message :String)  {
        if MFMessageComposeViewController.canSendText() {
            self.configuredMessageComposeViewController(message: message)
        }
    }
}
