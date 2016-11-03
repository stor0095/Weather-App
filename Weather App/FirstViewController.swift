//
//  FirstViewController.swift
//  Weather App
//
//  Created by Geemakun Storey on 2016-09-26.
//  Copyright © 2016 geemakunstorey@storeyofgee.com. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

extension CurrentWeather {
    var temperatureString: String {
        return "\(Int(temperature))º"
    }
    var humidityString: String {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    var precipitationProbabiltyString: String {
        let percentageValue = Int(precipProbability * 100)
        return "\(percentageValue)%"
    }
}

class FirstViewController: UIViewController {

    @IBOutlet weak var firstView: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var humidActivty: UIActivityIndicatorView!
    @IBOutlet weak var rainActivity: UIActivityIndicatorView!
    @IBOutlet weak var summaryActivity: UIActivityIndicatorView!
    @IBOutlet weak var activeTempIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var locationActivity: UIActivityIndicatorView!
    
    var colorModel = ColorModel()
    var coordinate: Coordinate?
    var manager = LocationManager()
    
    lazy var forecastAPIClient = ForeCastAPIClient(APIKey: "11881295a8d1e4ffb761d734d1f73970")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your Weather"
        
        locationActivity.startAnimating()
        activeTempIndicator.startAnimating()
        humidActivty.startAnimating()
        rainActivity.startAnimating()
        summaryActivity.startAnimating()
        let randomColor = colorModel.getRandomColor()
        view.backgroundColor = randomColor
        
        manager.getPermission()
        manager.onLocationFix = {[weak self] coordinate in
            self?.forecastAPIClient.fetchCurrentWeather(coordinate) { result in
                
                
                let latitude = coordinate.latitude
                let longitude = coordinate.longitude
                
                self?.toggleRefreshAnimation(false)
                self?.coordinate = coordinate
                switch result {
                case .success(let currentWeather):
                    self?.activeTempIndicator.stopAnimating()
                    self?.humidActivty.stopAnimating()
                    self?.rainActivity.stopAnimating()
                    self?.summaryActivity.stopAnimating()
                    self?.display(currentWeather)
                    self?.reverseGeocoding(latitude: latitude, longitude: longitude)
                case .failure(let error as NSError):
                    print("Unable to retrieve forecast \(error.localizedDescription)")
                default: break
                }
            }
        }
        
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCurrentWeather() {
        if let coordinate = coordinate {
        self.forecastAPIClient.fetchCurrentWeather(coordinate) { result in
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            self.toggleRefreshAnimation(false)
            switch result {
            case .success(let currentWeather):
                self.locationActivity.stopAnimating()
                self.activeTempIndicator.stopAnimating()
                self.humidActivty.stopAnimating()
                self.rainActivity.stopAnimating()
                self.summaryActivity.stopAnimating()
                self.display(currentWeather)
                self.reverseGeocoding(latitude: latitude, longitude: longitude)
            case .failure(let error as NSError):
                self.showAlert("Unable to retrieve forecast", message: error.localizedDescription)
            default: break
            }
        }
        }
    }
    
    func display(_ weather: CurrentWeather) {
        firstView.text = weather.temperatureString
        humidLabel.text = weather.humidityString
        popLabel.text = weather.precipitationProbabiltyString
        summaryLabel.text = weather.summary
        iconImage.image = weather.icon
    }

    
    @IBAction func refreshWeather(_ sender: AnyObject) {
        toggleRefreshAnimation(true)
        fetchCurrentWeather()
    }
    
    func toggleRefreshAnimation(_ on: Bool) {
        buttonOutlet.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if (placemarks?.count)! > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                let locationConcat = pm.addressDictionary?["City"] as? NSString
                let locationName = pm.addressDictionary?["Country"] as? NSString
               // print("LOCATION: \(locationConcat!), \(locationName!)")
                self.locationActivity.stopAnimating()
                self.locationLabel.text = "\(locationConcat!), \(locationName!)"
            }
            else {
                self.showAlert("Unable to retreive current location", message: "Try again later")
            }
        })
    }
    
    

}







