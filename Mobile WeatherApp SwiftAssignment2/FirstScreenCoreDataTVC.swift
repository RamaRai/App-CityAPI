//
//  FirstScreenCoreDataTVC.swift
//  First Screen will display cities if these cities are saved in CoreData already
//  First screen '+' button is segue to CitySearch TVC
//
//  Mobile WeatherApp SwiftAssignment2 Part1
//  Part1 City Api
//
//  Created by user152991 on 5/13/19.
//  Copyright © 2019 RamaRai. All rights reserved.
//

import UIKit
import CoreData

class FirstScreenCoreDataTVC: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate{
    
    let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    
    //initializing of array citylist from the database entity Cities
    
    lazy var fetchResult : NSFetchedResultsController<Cities> = {
        let FetchReq  : NSFetchRequest<Cities> = Cities.fetchRequest()
        
        //fetch request sorted on cityname
        let sort = NSSortDescriptor(key: "cityName", ascending: true)
        FetchReq.sortDescriptors = [sort]
        
        
        let fetchResult = NSFetchedResultsController(fetchRequest: FetchReq, managedObjectContext: myAppdelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self;
        return fetchResult
    }()
    
    
  //Search Bar to search favourite cities saved in coredata
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        var myPredicate : NSPredicate? = nil
        
        if (searchText.count > 0)
        {
            //filter or query in attribute cityName in entity
            myPredicate = NSPredicate(format: "cityName CONTAINS[c] %@", searchText)
        }
        //predicate condition is CONTAINS and [c] means any case upper or lower
        fetchResult.fetchRequest.predicate = myPredicate
        
        doFetch()
        tableView.reloadData()
        
    }

    //Function fetching data from CoreData
    func doFetch()
    {
        do{
            try fetchResult.performFetch()
        }catch{
            
        }
    }
    
    
    // Each time the TV is activated , fresh data is fetched and Table view is reloaded
        override func viewWillAppear(_ animated: Bool) {
        doFetch()
        tableView.reloadData()
    }
    
    
    //Initial loading of view
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doFetch()
    }
    
    
    //Deleting the row from database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let objectToRemove = fetchResult.object(at: indexPath)
            myAppdelegate.persistentContainer.viewContext.delete(objectToRemove)
            myAppdelegate.saveContext()
            
            //Fetch data from database and reload table
            doFetch()
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Table view data source
    
    //Number of sections in Table
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Number of rows in Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // to check if there are objects or data in the citylist
        //if let resultsunwrapped = citylist{
        //      return resultsunwrapped.count
        //   }
        return (fetchResult.fetchedObjects?.count ?? 0)
        // return 0
    }
    
    var cityselect = String()
    var path = NSIndexPath()
    
  //Populate (fetch to) table view with data from core data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citycell", for: indexPath)
        
        //Fill the Table View cells with data from database
        let thiscity = fetchResult.object(at:indexPath)
        cell.textLabel?.text = thiscity.cityName
        cell.detailTextLabel?.text=thiscity.country
        
        return cell
    }
    
 
   
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
