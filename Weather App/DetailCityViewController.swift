//
//  DetailCityViewController.swift
//  Weather App
//
//  Created by Geemakun Storey on 2016-09-26.
//  Copyright © 2016 geemakunstorey@storeyofgee.com. All rights reserved.
//

import UIKit


extension CurrentWeather {
    var tempString: String {
        return "\(Int(temperature))º"
    }
    var humidString: String {
        let percentageValue = Int(humidity * 100)
        return "\(percentageValue)%"
    }
    var popString: String {
        let percentageValue = Int(precipProbability * 100)
        return "\(percentageValue)%"
    }
}

class DetailCityViewController: UIViewController {

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cityImageIcon: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshIndictator: UIActivityIndicatorView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var initialIndictator: UIActivityIndicatorView!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var humidAct: UIActivityIndicatorView!
    @IBOutlet weak var rainActiv: UIActivityIndicatorView!
    @IBOutlet weak var summaryActiv: UIActivityIndicatorView!
    
   
    var colorModel = ColorModel()
    var City = String()
    var Latitude = Double()
    var Longitude = Double()
    
    lazy var forecastAPIClient = ForeCastAPIClient(APIKey: "11881295a8d1e4ffb761d734d1f73970")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = City
        locationLabel.text = City
        let randomColor = colorModel.getRandomColor()
        view.backgroundColor = randomColor
        
        initialIndictator.startAnimating()
        humidAct.startAnimating()
        rainActiv.startAnimating()
        summaryActiv.startAnimating()
        
        fetchCurrentWeather()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCurrentWeather() {
        let coordinate = Coordinate(latitude: Latitude, longitude: Longitude)
        forecastAPIClient.fetchCurrentWeather(coordinate) { result in
            self.toggleRefreshAnimation(false)
    
            switch result {
            case .success(let currentWeather):
                self.initialIndictator.stopAnimating()
                self.humidAct.stopAnimating()
                self.rainActiv.stopAnimating()
                
                self.summaryActiv.stopAnimating()
                self.display(currentWeather)
            case .failure(let error as NSError):
                self.showAlert("Unable to retrieve forecast", message: error.localizedDescription)
            default: break
            }
        }
        
    }
    func display(_ weather: CurrentWeather) {
        temperatureLabel.text = weather.temperatureString
        humidLabel.text = weather.humidityString
        popLabel.text = weather.precipitationProbabiltyString
        summaryLabel.text = weather.summary
        cityImageIcon.image = weather.icon
    }
    
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        toggleRefreshAnimation(true)
        fetchCurrentWeather()
    }
    
    func toggleRefreshAnimation(_ on: Bool) {
        refreshButton.isHidden = on
        if on {
            refreshIndictator.startAnimating()
        } else {
            refreshIndictator.stopAnimating()
        }
    }
    func showAlert(_ title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
