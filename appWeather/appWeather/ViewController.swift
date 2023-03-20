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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString =  "http://api.weatherstack.com/current?access_key=2b5a6e49306834779ea76ba4c518ee14&query=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))".encodeUrl
        let url = URL(string: urlString)
        
        guard let unwrappedUrl = url else {
            print("url = nil")
            return
        }
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
    
        let task = URLSession.shared.dataTask(with: unwrappedUrl) { [weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                as! [String : AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    temperature = current["temperature"] as? Double
                }
                
                DispatchQueue.main.async {
                    if errorHasOccured {
                        self?.cityLabel.text = "Error has occured"
                        self?.temperatureLabel.isHidden = true
                        
                    } else {
                        
                        self?.cityLabel.text = locationName
                        self?.temperatureLabel.text = "\(temperature!)"
                        
                        self?.temperatureLabel.isHidden = false
                        
                    }

                }
                
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        task.resume()
    }
}
