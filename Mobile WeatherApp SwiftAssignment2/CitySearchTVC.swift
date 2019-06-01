//
//  CitySearchTVC.swift
//  Mobile WeatherApp SwiftAssignment2
//
//  Created by user152991 on 5/13/19.
//  Copyright © 2019 RamaRai. All rights reserved.
//

import UIKit
import CoreData


// TVC has TC delegates by default and search delegate and downloader delegate
class CitySearchTVC : UITableViewController,UISearchBarDelegate,downloaderDelegate {
    
    // creating the array of cities from the data got from downloader
    //each time data is got the table is refreshed
    func downlaoderDidFinishWithCitiesArray(array: NSArray) {
        cityList = array as! [String]
        tableView.reloadData()
    }
    
    
    var cityList = [String]()
    var strcity = [String]()

    var myDownloader = downloader()
    var mypointerToPersistentContainer :NSPersistentContainer?
    
    
    // Loading initial view
    override func viewDidLoad() {
        super.viewDidLoad()
        myDownloader.delegate = self
       
    }
    
    // MARK: - Table view data source
    
    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Number fo rows is equal to number objects in array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityList.count
    }
    
    
   //Filling each row of table with object from array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        
         // cell.textLabel?.text = cityList[indexPath.row]
        
        // Breatking the array object atring into sub strings seperated by ,
        let  strcity = cityList[indexPath.row].components(separatedBy: ",")
        
        //Display City name as title of TV cell
        cell.textLabel?.text = strcity[0]
        // Display Province and Country as detail of TV cell
        cell.detailTextLabel?.text = strcity[1]+"' "+strcity[2]
    
        return cell
    }
    
    
    // Searching for cities from Cities API
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            
            //If city name has spaces it must be replaced by %20 format in url
            //as url CANNOT have space
            var mytext = searchText
            mytext = mytext.replacingOccurrences(of: " ", with: "%20")
            
            //Get list of cities matching with the search text in search bar
            myDownloader.getCities(city: mytext)
                }
    }
    
    lazy var myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newcity = NSEntityDescription.insertNewObject(forEntityName: "Cities", into: myAppdelegate.persistentContainer.viewContext) as! Cities
        
        // Breatking the array object atring into sub strings seperated by ,
        let  strcity = cityList[indexPath.row].components(separatedBy: ",")
        
        //Display City name as title of TV cell
        newcity.cityName = strcity[0]
        newcity.country = strcity[2]
        
        myAppdelegate.saveContext()
        
        
        // Creating a alert popup window to let user know the city is added
        let alert = UIAlertController.init(title: "City Added to the favourites", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "ok", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true,completion: nil)
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

