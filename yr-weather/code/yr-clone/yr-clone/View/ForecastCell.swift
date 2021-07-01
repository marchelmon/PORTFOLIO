//
//  ForecastCell.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-24.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    //MARK: - Properties
    
    var weather: WeatherModel? {
        didSet {
            configureCell()
        }
    }
    
    let hoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0000"
        return label
    }()
    
    let degreesLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8075824873, green: 0.187832036, blue: 0.1575775297, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "10ºC"
        return label
    }()
    
    let rainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let windLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4 m/s"
        label.textColor = UIColor(white: 0.1, alpha: 0.9)
        return label
    }()
    
    let weatherIcon = UIImageView()
    let windIcon = UIImageView()
    
    private lazy var timeTopLabel = createFirstRowLabel()
    private lazy var tempTopLabel = createFirstRowLabel()
    private lazy var rainTopLabel = createFirstRowLabel()
    private lazy var windTopLabel = createFirstRowLabel()
    
    
    //MARK: - Lifecycle
    
    
    //MARK: - Helpers
    
    func configureFirstRowCell() {
        selectionStyle = .none
        separatorInset = .zero
        emptyCell()
            
        timeTopLabel.text = "Time"
        tempTopLabel.text = "Temp. ºC"
        rainTopLabel.text = "Rain. mm"
        windTopLabel.text = "Wind. m/s"
        
        addSubview(timeTopLabel)
        timeTopLabel.anchor(left: safeAreaLayoutGuide.leftAnchor, bottom: bottomAnchor, paddingLeft: 20, paddingBottom: 10)
        
        addSubview(tempTopLabel)
        tempTopLabel.anchor(bottom: bottomAnchor, right: centerXAnchor, paddingBottom: 10, paddingRight: 20)
        
        addSubview(windTopLabel)
        windTopLabel.anchor(bottom: bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingBottom: 10, paddingRight: 15)
        
        addSubview(rainTopLabel)
        rainTopLabel.anchor(left: centerXAnchor, bottom: bottomAnchor, paddingLeft: 30, paddingBottom: 10)
    }
    
    
    func configureCell() {
        selectionStyle = .none
        separatorInset = .zero
        
        guard let weather = weather else { return }
        
        emptyCell()
        
        weatherIcon.image = nil
        windIcon.image = nil
        
        weatherIcon.image = weather.conditionIcon?.withRenderingMode(.alwaysOriginal)
        windIcon.image = weather.windDirectionIcon?.withTintColor(UIColor(white: 0.1, alpha: 0.9)).withRenderingMode(.alwaysOriginal)
                
        hoursLabel.text = getHourString(fromHour: weather.date.getHour())
        degreesLabel.text = weather.tempString
        if weather.rain != 0.0 { rainLabel.text = weather.rainString }
        windLabel.text = weather.windString

        
        addSubview(hoursLabel)
        hoursLabel.centerY(inView: self, leftAnchor: safeAreaLayoutGuide.leftAnchor, paddingLeft: 20)
        hoursLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(degreesLabel)
        degreesLabel.centerY(inView: self)
        degreesLabel.anchor(right: centerXAnchor, paddingRight: 20)
        
        contentView.addSubview(weatherIcon)
        weatherIcon.centerY(inView: self)
        weatherIcon.anchor(right: degreesLabel.leftAnchor, paddingRight: 20)
        
        
        contentView.addSubview(windIcon)
        windIcon.centerY(inView: self)
        windIcon.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 15)
        
        addSubview(windLabel)
        windLabel.centerY(inView: self)
        windLabel.anchor(right: windIcon.leftAnchor, paddingRight: 8)
        
        addSubview(rainLabel)
        rainLabel.centerY(inView: self)
        rainLabel.anchor(left: centerXAnchor, paddingLeft: 30)
        
    }
    
    func emptyCell() {
        timeTopLabel.text = ""
        rainTopLabel.text = ""
        tempTopLabel.text = ""
        windTopLabel.text = ""
        weatherIcon.image = nil
        windIcon.image = nil
        hoursLabel.text = ""
        degreesLabel.text = ""
        windLabel.text = ""
        rainLabel.text = ""
    }
    
    
    func getHourString(fromHour hour: Int) -> String {
        
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        
        var upcomingHourString = (hour + 3) < 10 ? "0\(hour + 3)" : "\(hour + 3)"
        
        if (hour + 3) > 24 {
            upcomingHourString = "0\(hour - 21)"
        }
        
        return "\(hourString)-\(upcomingHourString)"
    }
    
    func createFirstRowLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }
    
}
