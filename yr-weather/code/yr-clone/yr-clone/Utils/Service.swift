//
//  Service.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-16.
//

import UIKit
import CoreLocation

class Service {
    
    static let shared = Service()
    
    var currentLocation: CLLocationCoordinate2D?
    
    var lastForecast: WeatherModel?
    var favoriteLocations = [WeatherModel]()
    
    func getSettingData(fromType type: SettingType) -> [String] {
        switch type {
        case .start: return Dummy.shared.startData
        case .temp: return Dummy.shared.tempData
        case .wind: return Dummy.shared.windData
        case .length: return Dummy.shared.lengthData
        case .language: return Dummy.shared.languageData
        case .notifications: return Dummy.shared.notificationsData
        case .mainLocation: return Dummy.shared.mainLocationData
        case .locationBased: return Dummy.shared.locationBasedData
        }
    }
    
    func getItemFromSettingData(withType type: SettingType, withIndex index: Int) -> String {
        
        switch type {
        case .start: return Dummy.shared.startData[index]
        case .temp: return Dummy.shared.tempData[index]
        case .wind: return Dummy.shared.windData[index]
        case .length: return Dummy.shared.lengthData[index]
        case .language: return Dummy.shared.languageData[index]
        case .notifications: return Dummy.shared.notificationsData[index]
        case .mainLocation: return Dummy.shared.mainLocationData[index]
        case .locationBased: return Dummy.shared.locationBasedData[index]
        }
    }
    
    func prepareStringForAPI(string: String) -> String {
        var apiString = ""
        for char in string {
            apiString.append(char == " " ? "+" : char)
        }
        return apiString
    }
    
}
