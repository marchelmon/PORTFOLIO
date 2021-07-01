//
//  DummyData.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-19.
//

import UIKit


class Dummy {
    
    static let shared = Dummy()
    
    let randomCities = ["London", "New York", "Gothenbur", "Stockholm", "Copenhagen", "Washington", "Malmö", "Oslo", "Helsinki", "Berlin", "Amsterdam", "Rome", "Madrid", "Barcelona", "Malaga", "Milano", "Gdansk", "Moskow", "Sydney", "Toronto"]
    
    let settingRows: [SettingsRow]
    
    let startData = ["Table", "Sky", "Graph"]
    let tempData = ["Celsius", "Fahrenheit"]
    let windData = ["Meters per second (m/s)", "Knots (k/t)", "Kilmoeters per hour (km/h)", "Imperial miles per hour (mph)", "Beaufort (B)"]
    let lengthData = ["Meters", "Feet"]
    let languageData = ["English", "Svenska"]
    let notificationsData = ["Get a short summary of the weather"]
    let mainLocationData = ["Location-based forecast", "Saved location"]
    let locationBasedData = ["Yes", "No"]

    init() {
        let sunIcon = UIImage(systemName: "sun.max")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        let tempIcon = UIImage(systemName: "thermometer.sun")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        let windIcon = UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        let lengthIcon = UIImage(systemName: "ruler")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        let languageIcon = UIImage(systemName: "globe")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        let bellIcon = UIImage(systemName: "bell")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        let mainLocationIcon = UIImage(systemName: "stopwatch")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray)
        
        settingRows = [
            SettingsRow(withSettingType: .start, text: "Start page", selectionText: startData[0], icon: sunIcon, hasArrow: true),
            SettingsRow(withSettingType: .temp, text: "Temperature", selectionText: tempData[0], icon: tempIcon, hasArrow: true),
            SettingsRow(withSettingType: .wind, text: "Wind", selectionText: windData[0], icon: windIcon, hasArrow: true),
            SettingsRow(withSettingType: .length, text: "Length", selectionText: lengthData[0], icon: lengthIcon, hasArrow: true),
            SettingsRow(withSettingType: .language, text: "Language", selectionText:languageData[0], icon: languageIcon, hasArrow: true),
            SettingsRow(withSettingType: .notifications, text: "Notifications", selectionText: notificationsData[0], icon: bellIcon, hasArrow: true),
            SettingsRow(withSettingType: .mainLocation, text: "Default location", selectionText: mainLocationData[0], icon: mainLocationIcon, hasArrow: true),
            SettingsRow(withSettingType: .locationBased, text: "Location-based forecast", selectionText: locationBasedData[0], icon: nil, hasArrow: true)
        ]
    }
}
