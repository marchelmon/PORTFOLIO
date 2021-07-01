//
//  SettingsRow.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-16.
//

import UIKit


enum SettingType {
    case start
    case temp
    case wind
    case length
    case language
    case notifications
    case locationBased
    case mainLocation
}

struct SettingsRow {
    let type: SettingType
    let icon: UIImage?
    let text: String
    let selectionText: String
    let hasArrow: Bool
    
    init(withSettingType type: SettingType, text: String, selectionText: String, icon: UIImage?, hasArrow: Bool) {
        self.type = type
        self.text = text
        self.selectionText = selectionText
        self.icon = icon
        self.hasArrow = hasArrow
    }
}
