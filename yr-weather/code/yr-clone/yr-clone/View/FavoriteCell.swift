//
//  FavoriteCell.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-28.
//

import UIKit


class FavoriteCell: UITableViewCell {
    
    //MARK: - Properties

    var weather: WeatherModel? {
        didSet {
            guard weather != nil else { return }
            configureCell()
        }
    }

    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0.1, alpha: 0.8)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Bermuda"
        return label
    }()

    let degreesLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8075824873, green: 0.187832036, blue: 0.1575775297, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "10ºC"
        return label
    }()

    let weatherIcon = UIImageView()
    
    let starImage = UIImage(systemName: "star")?.withTintColor(.lightGray).withRenderingMode(.alwaysOriginal)
    let fillStarImage = UIImage(systemName: "star.fill")?.withTintColor(.link).withRenderingMode(.alwaysOriginal)
    
    lazy var starIcon: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(pressedStar), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Actions
    
    @objc func pressedStar() {
        starIcon.imageView?.image = nil
        print("Pressed star")
        let index = Service.shared.favoriteLocations.firstIndex { favorite -> Bool in
            return favorite.city.name == weather?.city.name
        }
        if index != nil {
            Service.shared.favoriteLocations.remove(at: index!)
            starIcon.setImage(starImage, for: .normal)
        } else {
            Service.shared.favoriteLocations.append(weather!)
            starIcon.setImage(fillStarImage, for: .normal)
        }
    }
    
    func configureCell() {
        guard let weather = weather else { return }
        
        let index = Service.shared.favoriteLocations.firstIndex(where: { favorite -> Bool in
            return favorite.city.name == weather.city.name
        })
        let currentStarImage = index == nil ? starImage : fillStarImage
        starIcon.setImage(currentStarImage, for: .normal)
        
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 30)
        weatherIcon.image = weather.conditionIcon?.withRenderingMode(.alwaysOriginal).withConfiguration(imgConfig)
                
        locationLabel.text = weather.city.name
        degreesLabel.text = weather.tempString
        
        contentView.addSubview(starIcon)
        starIcon.centerY(inView: self, leftAnchor: safeAreaLayoutGuide.leftAnchor, paddingLeft: 15)
        
        addSubview(locationLabel)
        locationLabel.centerY(inView: self, leftAnchor: starIcon.rightAnchor, paddingLeft: 10)
        
        addSubview(weatherIcon)
        weatherIcon.centerY(inView: self)
        weatherIcon.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 15)
        
        addSubview(degreesLabel)
        degreesLabel.centerY(inView: self)
        degreesLabel.anchor(right: weatherIcon.leftAnchor, paddingRight: 5)
    }
    
}

