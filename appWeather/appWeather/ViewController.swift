//
//  ViewController.swift
//  appWeather
//
//  Created by Vadim Baburin on 06.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //var locationName: String?
    //var temperature: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar.delegate = self
        
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchBarUnwrappedText = searchBar.text else {
            print("text = nil")
            return
        }
        
        let urlString =  "http://api.weatherstack.com/current?access_key=2b5a6e49306834779ea76ba4c518ee14&query=\(searchBarUnwrappedText.replacingOccurrences(of: " ", with: "%20"))".encodeUrl
        let url = URL(string: urlString)
        
        guard let unwrappedUrl = url else {
            print("url = nil")
            return
        }
        
        
      //  var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: unwrappedUrl) { [weak self] (data, response, error) in
            do {
                guard let unwrappedData = data else {
                    print("data = nil")
                    return
                }
                
                let json = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers)
                as! [String : AnyObject]
                
                if let error = json["error"] {
                    self?.fillLabelError(errorInfo: error["info"] as? String)
                   // errorHasOccured = true
                }
                
                if let location = json["location"],
                   let current = json["current"] {
                    self?.fillLabels(locationName: location["name"] as? String,
                                     temperature: current["temperature"] as? Double
                    )
                    
                }
                
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
        
    }
    
    func fillLabelError(errorInfo: String?) {

        DispatchQueue.main.async {
        
            self.cityLabel.text = errorInfo
            self.temperatureLabel.isHidden = true
            
        }
    }
    
    func fillLabels(locationName: String?, temperature: Double?) {

        DispatchQueue.main.async {
            self.cityLabel.text = locationName
            
            guard let unwrappedTemperature = temperature else {
                print("temperature = nil")
                return
            }
            
            self.temperatureLabel.text = "\(unwrappedTemperature)"
            self.temperatureLabel.isHidden = false
        }
    }
}
