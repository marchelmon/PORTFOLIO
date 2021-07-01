//
//  SearchCityController.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-26.
//

import UIKit
import CoreLocation

private let currentLocationCell = "CurrentCell"
private let resultCell = "ResultCell"

protocol SearchCityDelegate: class {
    func didSelectCity(city: String)
}

class SearchCityController: UITableViewController {
    
    //MARK: - Properties
    
    var delegate: SearchCityDelegate?
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    
    var currentLocationWeather: WeatherModel?
    
    var searchResults = [String]()
    var isEditingSearch = false

    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "My locations"
        return label
    }()
    
    private let headerSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search city"
        bar.returnKeyType = .go
        return bar
    }()
    
    private lazy var tableHeader: UIView = {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 140))
        
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        header.addSubview(searchBar)
        searchBar.centerY(inView: header, leftAnchor: header.leftAnchor, paddingLeft: 20, constant: 20)
        searchBar.anchor(right: header.rightAnchor, paddingRight: 20)
        
        let icon = UIImageView(image: #imageLiteral(resourceName: "yr-icon").withRenderingMode(.alwaysOriginal))
        icon.setDimensions(width: 40, height: 40)
        header.addSubview(icon)
        icon.centerY(inView: header, constant: -10)
        icon.centerX(inView: searchBar)
        
        return header
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager.delegate = self
        weatherManager.delegate = self
        
        tableView.tableHeaderView = tableHeader
        tableView.separatorStyle = .none
        tableView.register(LocationCell.self, forCellReuseIdentifier: currentLocationCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCell)
        
        guard let currentLocation = Service.shared.currentLocation else { return }
        weatherManager.fetchWeather(withLatitude: currentLocation.latitude, withLongitude: currentLocation.longitude)
        
        
    }
    
    //MARK: - Actions
    
    
    //MARK: - Helpers
    
}


//MARK: - TableViewDelegate and DataSource

extension SearchCityController {
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return section == 0 ? searchResults.count : 1 }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return indexPath.section == 0 ? 50 : 80 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: currentLocationCell) as! LocationCell
            if currentLocationWeather != nil {
                cell.weather = currentLocationWeather
                cell.addNavIcon()
            } else {
                cell.configureGetLocation()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            delegate?.didSelectCity(city: searchResults[indexPath.row])
        }
        if indexPath.section == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! LocationCell
            if let cityName = cell.weather?.city.name {
                let cityString = Service.shared.prepareStringForAPI(string: cityName)
                delegate?.didSelectCity(city: cityString)
            } else {
                getUserLocation()
            }
        }
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

//MARK: - WeatherManagerDelegate
extension SearchCityController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print("Fetch Weather error: \(error.localizedDescription)")
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        currentLocationWeather = weather
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didUpdateForecast(_ weatherManager: WeatherManager, forecastData: [WeatherModel]) {
        print("Updated forecst in searchcitycontroller")
    }
}

//MARK: - UISearchBarDelegate
extension SearchCityController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEditingSearch = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isEditingSearch = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = []
        let text = searchText.lowercased()
        
        Dummy.shared.randomCities.forEach { city in
            let cityLowercased = city.lowercased()
            if cityLowercased.range(of: text) != nil {
                searchResults.append(city)
            }
        }
        tableView.reloadData()
    }
    
}


//MARK: - CLLocationManagerDelegate
extension SearchCityController: CLLocationManagerDelegate {
    func getUserLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied: locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways: locationManager.startUpdatingLocation()
        case .authorizedWhenInUse: locationManager.startUpdatingLocation()
        @unknown default: print("Get location bull") }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        Service.shared.currentLocation = coordinate

        weatherManager.fetchWeather(withLatitude: coordinate.latitude, withLongitude: coordinate.longitude)

        locationManager.stopUpdatingLocation()
    }
}




