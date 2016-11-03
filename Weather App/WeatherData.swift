//
//  WeatherData.swift
//  Weather App
//
//  Created by Geemakun Storey on 2016-09-26.
//  Copyright © 2016 geemakunstorey@storeyofgee.com. All rights reserved.
//

import Foundation

struct Location {
    let title: String?
    let latitude: Double
    let longitude: Double
}

let locations = [
    Location(title: "Moosonee, ON",latitude: 51.2731, longitude: 80.6400),
    Location(title: "Attawapiskat, ON",latitude: 52.9259, longitude: 82.4289),
    Location(title: "Toronto, ON",latitude: 43.6532, longitude: 79.3832),
    Location(title: "New York, NY", latitude: 40.713054, longitude: -74.007228),
    Location(title: "Los Angeles, CA",latitude: 34.052238, longitude: -118.243344),
    Location(title: "London, UK", latitude: 51.5074, longitude: 0.1278),
    Location(title: "Rio de Janeiro, BR",latitude: 22.9068, longitude: 43.1729),
    Location(title: "Paris, FR",latitude: 48.8566, longitude: 2.3522),
    Location(title: "Berlin, GR",latitude: 52.5200, longitude: 13.4050),
    Location(title: "Warsaw, PL",latitude: 52.2297, longitude: 21.0122),
    Location(title: "Moscow, RU",latitude: 55.7558, longitude: 37.6173),
    Location(title: "Cairo, EG",latitude: 30.0444, longitude: 31.2357),
    Location(title: "Tokyo, JA",latitude: 35.6895, longitude: 139.6917),
    Location(title: "Sydney, AU",latitude: 33.8688, longitude: 151.2093),
    Location(title: "Honolulu, HW",latitude: 21.3069, longitude: 157.8583),
    Location(title: "Vancouver, BC",latitude: 49.2827, longitude: 123.1207),
    Location(title: "Winnipeg, MB",latitude: 49.8998, longitude: 97.1375),
]


enum ForecastDetail: Endpoint {
    case Current(token: String, coordinateCity: Coordinate)
    
    var baseURL: URL {
        return URL (string: "https://api.darksky.net")!
    }
    var path: String {
        switch self {
        case .Current(let token, let coordinateCity):
            return "/forecast/\(token)/\(coordinateCity.latitude),\(coordinateCity.longitude)"
        }
    }
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        return (URLRequest(url: url) as NSURLRequest) as URLRequest
    }
}

final class ForecastDetailAPIClient: APIClient {
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    fileprivate let token: String
    
    init(config: URLSessionConfiguration, APIKey: String) {
        self.configuration = config
        self.token = APIKey
    }
    
    convenience init(APIKey: String){
        self.init(config: URLSessionConfiguration.default, APIKey: APIKey)
    }
    
    func fetchCurrentWeather(_ coordinateCity: Coordinate, completion: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastDetail.Current(token: self.token, coordinateCity: coordinateCity).request
        
        fetch(request, parse: { (json) -> CurrentWeather? in
            // Parse from JSON repsonse to current weather
            if let currentWeatherDictionary = json["currently"] as? [String: AnyObject] {
                return CurrentWeather(JSON: currentWeatherDictionary)
                
            } else {
                return nil
            }
            }, completion: completion)
    }
    
}

