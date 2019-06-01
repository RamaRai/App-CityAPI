//
//  Downloader.swift
//  Mobile WeatherApp SwiftAssignment2 Part1
//  Part1 City Api
//
//  Created by user152991 on 5/13/19.
//  Copyright © 2019 RamaRai. All rights reserved.
//

import Foundation

// Gets the data array of cities using the protocol, once is done its work
//Use protocol always when working with multi threads

protocol downloaderDelegate {
    func downlaoderDidFinishWithCitiesArray(array : NSArray)
    //func downloadDidfinishWithWeather(set :NSSet)
}


//
class downloader {
    
    var delegate : downloaderDelegate?
    
    func getData(urlObject : URL , completionHandler : @escaping (Data)->())  {
        
        //using API server to work on dynamic data, Sessions are created for as net request --- step 3
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        
        //Working on Data to check if there is data to be returned
        //Datatask takes a parameter url and completion Handler the code in completionHandler creates a thread for data task
        let task = session.dataTask(with: urlObject) { (data, respons, error) in
            
            //If Data is returned then working on this Json else error
            if let myData = data {
                
                // converting unvalid data to string --- step 4
                var stringFromJson = String(decoding: myData, as: UTF8.self)
                
                //process to create valid json by removing extra characters in the begining and at end of the string
                
                stringFromJson = stringFromJson.replacingOccurrences(of: "?(", with: "")
                stringFromJson = stringFromJson.replacingOccurrences(of: ");", with: "")
                
                //converting the string to valid json data
                let validDataFromAPI = stringFromJson.data(using: .utf8)
                
                // Completion Handler returns valid Json
                completionHandler(validDataFromAPI!)
            }
            else {
                print("error in downloadeing \(String(describing: error))" )
            }
        }
        task.resume()
        
    }
    
    func getWeather(city: String) {
        
        /// Using the API link with the query to get the City names --- step 2
        let urlString =  "https://api.openweathermap.org/data/2.5/weather?q=Dubai&appid=b21cf8f8014b247382e4d347181857dc"
        
        //  Converting the string url to url object
        let urlObject : URL = URL(string: urlString)!
        
        //Calling getData function by passing the url object
        getData(urlObject: urlObject) { (data) in
            do{
                
                // Searializing valid Json as array --- step 5
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                
                //Joining back the main thread
                DispatchQueue.main.async {
                    self.delegate?.downlaoderDidFinishWithCitiesArray(array: json)
                    
                }
                
            }catch{
                
            }
            
        }
        //getData finish
        
    }


    
    func getCities(city : String)  {
        // Using the API link with the query to get the City names --- step 2
        let urlString =  "http://gd.geobytes.com/AutoCompleteCity?callback=?&q="  + city
      
        //  Converting the string url to url object
        let urlObject : URL = URL(string: urlString)!
        
        //Calling getData function by passing the url object
        getData(urlObject: urlObject) { (data) in
            do{
                
                // Searializing valid Json as array --- step 5
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                
                //Joining back the main thread
                DispatchQueue.main.async {
                    self.delegate?.downlaoderDidFinishWithCitiesArray(array: json)
                    
                    }
                
            }catch{
                
                }
        
            }
        
        }

}
