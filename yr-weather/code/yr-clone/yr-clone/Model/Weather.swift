//
//  Weather.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-20.
//

import UIKit

//MARK: - WeatherModel

struct WeatherModel {
    let conditionId: Int
    let description: String
    let city: City
    let temp: Int
    let wind: Wind
    let rain: Double
    let date: Date
    let dateHeader: String
    
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
    
    var tempString: String {
        return "\(temp)º"
    }
    
    var rainString: String {
        return String(format: "%.1f", rain)
    }
    
    var windString: String {
        return String(format: "%.1f", wind.speed)
    }
    
    var sunsetString: String {
        let rise = Date(timeIntervalSince1970: city.sunrise)
        let riseHour = rise.getHour() < 10 ? "0\(rise.getHour())" : "\(rise.getHour())"
        let riseMinute = rise.getMinute() < 10 ? "0\(rise.getMinute())" : "\(rise.getMinute())"
        
        let set = Date(timeIntervalSince1970: city.sunset)
        let setHour = set.getHour() < 10 ? "0\(set.getHour())" : "\(set.getHour())"
        let setMinute = set.getMinute() < 10 ? "0\(set.getMinute())" : "\(set.getMinute())"
        
        return "Sunrise: \(riseHour):\(riseMinute)  -  Sunset: \(setHour):\(setMinute)"
    }
    
    var conditionIcon: UIImage? {
        switch conditionId {
        case 200...232:
            return UIImage(systemName: "cloud.bolt", withConfiguration: imageConfig)?.withTintColor(.gray)
        case 300...321:
            return UIImage(systemName: "cloud.drizzle", withConfiguration: imageConfig)?.withTintColor(.gray)
        case 500...504:
            return UIImage(systemName: "cloud.sun.rain", withConfiguration: imageConfig)?.withTintColor(.gray)
        case 505...531:
            return UIImage(systemName: "cloud.rain", withConfiguration: imageConfig)?.withTintColor(.gray)
        case 600...622:
            return UIImage(systemName: "cloud.snow", withConfiguration: imageConfig)?.withTintColor(.gray)
        case 701...781:
            return UIImage(systemName: "cloud.fog", withConfiguration: imageConfig)?.withTintColor(.gray)
        case 800:
            return UIImage(systemName: "sun.max.fill", withConfiguration: imageConfig)?.withTintColor(.systemYellow)
        case 801:
            return UIImage(systemName: "cloud.sun", withConfiguration: imageConfig)?.withTintColor(.gray)
        default:
            return UIImage(systemName: "cloud", withConfiguration: imageConfig)?.withTintColor(.gray)
        }
    }
    
    var windDirectionIcon: UIImage? {
        switch wind.deg {
        case 0...23, 338...360:
            return UIImage(systemName: "arrow.up")
        case 24...69:
            return UIImage(systemName: "arrow.up.right")
        case 70...105:
            return UIImage(systemName: "arrow.right")
        case 106...150:
            return UIImage(systemName: "arrow.down.right")
        case 151...196:
            return UIImage(systemName: "arrow.down")
        case 197...242:
            return UIImage(systemName: "arrow.down.left")
        case 243...288:
            return UIImage(systemName: "arrow.left")
        case 289...337:
            return UIImage(systemName: "arrow.up.left")
        default:
            return UIImage(systemName: "circle")
        }
    }
}

//MARK: - WeahterData

struct ForecastData: Decodable {
    let list: [Forecast]
    let city: City
}

struct Forecast: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let rain: Rain?
    let dt: Double
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let rain: Rain?
    let sys: Sys
}

struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    let description: String
    let id: Int
}
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
struct Rain: Codable {
    let threeHour: Double?
    let oneHour: Double?
    
    private enum CodingKeys : String, CodingKey {
        case threeHour = "3h"
        case oneHour = "1h"
    }
}
struct City: Decodable {
    let name: String
    let sunrise: Double
    let sunset: Double
}

struct Sys: Decodable {
    let sunrise: Double
    let sunset: Double
}



