//
//  FavoritesController.swift
//  yr-clone
//
//  Created by marchelmon on 2021-06-16.
//

import UIKit

private let favoriteCell = "FavoriteCell"

class FavoritesController: UITableViewController {
    
    //MARK: - Properties
    
    var weatherManager = WeatherManager()
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: favoriteCell)
        
        weatherManager.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = Service.shared.lastForecast?.city.name ?? "Nomansland"

        tableView.reloadData()
    }
    

    //MARK: - Actions
    
    @IBAction func addNewFavorite(_ sender: UIBarButtonItem) {
        let controller = SearchCityController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - UITableViewDelegate / UITableViewDataSource
extension FavoritesController {
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return Service.shared.favoriteLocations.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCell) as! FavoriteCell
        
        cell.weather = Service.shared.favoriteLocations[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! FavoriteCell
        guard let cityName = cell.weather?.city.name else { return }
        guard let navController = tabBarController?.viewControllers?.first as? UINavigationController else { return }
        guard let forecastController = navController.viewControllers.first as? ForecastController else { return }
        
        let cityString = Service.shared.prepareStringForAPI(string: cityName)
        forecastController.weatherManager.fetchForecast(forCity: cityString)
        tabBarController?.selectedIndex = 0

    }
    
}

//MARK: - SearchCityDelegate

extension FavoritesController: SearchCityDelegate {
    func didSelectCity(city: String) {
        weatherManager.fetchWeather(forCity: city)
    }
}


//MARK: - WeatherManagerDelegate
extension FavoritesController: WeatherManagerDelegate {
    func didFailWithError(error: Error) { print("Error: \(error.localizedDescription)") }
    func didUpdateForecast(_ weatherManager: WeatherManager, forecastData: [WeatherModel]) { print("Did update forecast") }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        Service.shared.favoriteLocations.append(weather)
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.tableView.reloadData()
        }
    }
    
}
