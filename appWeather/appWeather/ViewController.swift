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
    
    let service = AppWeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let searchBarUnwrappedText = searchBar.text else {
            print("text = nil")
            return
        }
        
        service.getSearchInformation(searchText: searchBarUnwrappedText, completion:  { response in
            guard let responseError = response.error?.info else {
                self.fillLabels(locationName: response.location?.name, temperature: response.current?.temperature)
                return
            }
            self.fillLabelError(errorInfo: responseError)
        })
        
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
