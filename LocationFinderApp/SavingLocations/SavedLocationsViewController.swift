//
//  SavedLocationsViewController.swift
//  LocationFinderApp
//
//  Created by Atul Bhaisare on 5/20/19.
//  Copyright © 2019 Atul Bhaisare. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class SavedLocationsViewController: BaseViewController{
   
    @IBOutlet weak var locationsTable: UITableView!
    
    var resultsController: NSFetchedResultsController<Location>!
    var locationsArray : [Location] = []
    var placesArray : [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  NSLocalizedString("kPlacesVCTitle", comment: "")
        locationsTable.tableFooterView = UIView()
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationsTable.reloadData()
        
    }
    
    // MARK: - CoreData FetchRequest
    
    func getData()  {
        //Create request
        let request : NSFetchRequest<Location> = Location.fetchRequest()
        
        //let's sort our properties by date
        let sortDescriptorsDate = NSSortDescriptor(key: "latitude", ascending: true)   //ascending = true => latest entries are at the top
        
        request.sortDescriptors = [sortDescriptorsDate]
        
        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.sharedManager.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        
        do{
            let records = try CoreDataStack.sharedManager.mainContext.fetch(request)
            for record in records {
                locationsArray.append(record)
                guard let address = record.address else {return}
                guard let locationDescription = record.locationDescription else {return}
                let clLocation = CLLocation(latitude: record.latitude, longitude: record.longitude)
                let place = Place(address: address, description: locationDescription, location: clLocation)
                placesArray.append(place)
            }
            try resultsController.performFetch()
        }catch{
            print("Error in fetching data")
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func showAllLocations(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let gMapViewController =  storyBoard.instantiateViewController(withIdentifier: "GMapViewController") as? GMapViewController
            else {
                return }
        gMapViewController.showAllLocationFlag = true
        gMapViewController.placesArray = self.placesArray
        self.navigationController?.pushViewController(gMapViewController, animated: false)
        
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let enterLocViewController =  storyBoard.instantiateViewController(withIdentifier: "EnterLocationViewController") as? EnterLocationViewController
            else {
                return
        }
        enterLocViewController.locationProtocolDelegate = self
        self.navigationController?.pushViewController(enterLocViewController, animated: false)
        
    }
}


  // MARK: - TableviewDataSource

extension SavedLocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return resultsController.sections?.first?.numberOfObjects ?? 0
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? PlaceTableViewCell else {return UITableViewCell()}
        let place = placesArray[indexPath.row]
        cell.lblAddress?.text = place.address
        cell.lblDescrpition?.text = place.description
        return cell
    }
}

 // MARK: - TableviewDelegates

extension SavedLocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let gMapViewController =  storyBoard.instantiateViewController(withIdentifier: "GMapViewController") as? GMapViewController
            else {
                return }
        gMapViewController.selectedLocation = self.placesArray[indexPath.row]
        self.navigationController?.pushViewController(gMapViewController, animated: false)
    }
    
    //tableViewDelegate method for swipe action deleting rows
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            //delete to do
            let locationObj = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(locationObj)
            self.placesArray.remove(at: indexPath.row)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            }
            catch{
                print("Couldn't delete the row: \(error.localizedDescription)")
            }
        }
        swipeAction.image = UIImage(named: "deleteIcon")
        swipeAction.backgroundColor = UIColor.yellow
        
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            //delete to do
            let locationObj = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(locationObj)
            self.placesArray.remove(at: indexPath.row)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            }
            catch{
                print("Couldn't delete the row: \(error.localizedDescription)")
            }
            
        }
        swipeAction.image = UIImage(named: "deleteIcon")
        swipeAction.backgroundColor = UIColor.blue
        
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
}

extension SavedLocationsViewController:GetNewLocationProtocol{
   
    func sendNewLocation(place: Place) {
        placesArray.append(place)
    }
}

// MARK: - Core data fetch delegate

extension SavedLocationsViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        locationsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        locationsTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath{    //without this case, even when the swipe action removed the row, on reloading the app, the previously deleted row would show up
                locationsTable.deleteRows(at: [indexPath], with: .automatic)
            }
            
        default:
            break
        }
        
    }
    
}
