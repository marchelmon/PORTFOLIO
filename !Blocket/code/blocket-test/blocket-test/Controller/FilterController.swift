//
//  FilterController.swift
//  blocket-test
//
//  Created by marchelmon on 2021-06-13.
//

import UIKit
import MapKit

private let filterCellIdentifier = "FilterCell"

class FilterController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    
    private let locationManager: CLLocationManager = LocationHandler.shared.locationManager
    
    private var categoryIndex = 0
    private var locationIndex = 0
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = CGSize(width: view.frame.width, height: 1100)
        scroll.delegate = self
        return scroll
    }()
    
    var sortingPickerIsVisible: Bool = false
    var advertiserPickerIsVisible: Bool = false
    var kindOfAdPickerIsVisible: Bool = false
    
    private let sortingData = ["Latest", "Oldest", "Cheapest", "Most expensive"]
    private lazy var sortingPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 0
        return picker
    }()
    
    private let advertiserData = ["All", "Private seller", "Company seller"]
    private lazy var advertiserPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 1
        return picker
    }()
    
    
    private let kindOfAdData = ["For sale", "For trade", "For rent", "Wish to rent", "To buy",]
    private lazy var kindOfAdPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = 2
        return picker
    }()
    
    private let locationSectionHeader = FilterSectionHeader(headerText: "LOCATION")
    private let categorySectionHeader = FilterSectionHeader(headerText: "CATEGORY")
    private let pickersSectionHeader = FilterSectionHeader(headerText: "SORTING AND KIND")
    private let onlyShowSectionHeader = FilterSectionHeader(headerText: "SHOW")
    
    private lazy var locationRow = FilterRow(rowType: .location, delegate: self, labelText: "Location", isFirstInSection: true)
    private lazy var nearbyRow = FilterRow(rowType: .usingToggle, delegate: self, labelText: "Nearby areas")
    private lazy var currentLocationRow = FilterRow(rowType: .currentLocation, delegate: self, labelText: "Find current location", isLastInSection: true)
    private lazy var categoryRow = FilterRow(rowType: .category, delegate: self, labelText: "Category", isFirstInSection: true, isLastInSection: true)
    private lazy var sortingRow = FilterRow(rowType: .sorting, delegate: self, labelText: "Sort by", isFirstInSection: true)
    private lazy var advertiserKindRow = FilterRow(rowType: .advertiserKind, delegate: self, labelText: "Advertiser kind")
    private lazy var adKindRow = FilterRow(rowType: .adKind, delegate: self, labelText: "Ad kind", isLastInSection: true)
    private lazy var loweredPriceRow = FilterRow(rowType: .usingToggle, delegate: self, labelText: "Lowered price only", isFirstInSection: true)
    private lazy var largeImagesRow = FilterRow(rowType: .usingToggle, delegate: self, labelText: "Large Images", isLastInSection: true)
        
    private let filterButton: BlocketButton = {
        let button = BlocketButton(text: "Set Filter", color: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), textColor: .white)
        button.addTarget(self, action: #selector(handleSetFilter), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Filter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissFilter))
        navigationItem.backButtonTitle = "Cancel"
        navigationController?.navigationItem.backBarButtonItem = .init(title: "Cancel", style: .done, target: self, action: #selector(dismissFilter))
        
        locationManager.delegate = self
        
        configureSectionsAndRows()
     
        view.addSubview(filterButton)
        filterButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15, height: 50)
        
    }
    
    
    //MARK: - Actions
    
    @objc func dismissFilter() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSetFilter() {
        print("Should set filter")
    }
    
    //MARK: - Helpers
    
    func configureSectionsAndRows() {
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        //LOCATION
        scrollView.addSubview(locationSectionHeader)
        locationSectionHeader.anchor(top: scrollView.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 60)
        
        let locationStack = UIStackView(arrangedSubviews: [locationRow, nearbyRow, currentLocationRow])
        locationStack.axis = .vertical
        
        scrollView.addSubview(locationStack)
        locationStack.anchor(top: locationSectionHeader.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        //CATEGORY
        scrollView.addSubview(categorySectionHeader)
        categorySectionHeader.anchor(top: locationStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 60)
        
        scrollView.addSubview(categoryRow)
        categoryRow.anchor(top: categorySectionHeader.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        //PICKERS
        scrollView.addSubview(pickersSectionHeader)
        pickersSectionHeader.anchor(top: categoryRow.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 60)
        
        scrollView.addSubview(sortingRow)
        sortingRow.anchor(top: pickersSectionHeader.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
 
        
        scrollView.addSubview(advertiserKindRow)
        advertiserKindRow.anchor(top: sortingRow.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(adKindRow)
        adKindRow.anchor(top: advertiserKindRow.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(onlyShowSectionHeader)
        onlyShowSectionHeader.anchor(top: adKindRow.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 60)
        
        scrollView.addSubview(loweredPriceRow)
        loweredPriceRow.anchor(top: onlyShowSectionHeader.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        scrollView.addSubview(largeImagesRow)
        largeImagesRow.anchor(top: loweredPriceRow.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
    }

}


//MARK: - UITableViewDelegate / UITableViewDataSource

extension FilterController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0: return 4
        case 1: return 3
        case 2: return 5
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0: sortingRow.optionText.text = sortingData[row]
        case 1: advertiserKindRow.optionText.text = advertiserData[row]
        case 2: adKindRow.optionText.text = kindOfAdData[row]
        default: print("Default selected")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0: return sortingData[row]
        case 1: return advertiserData[row]
        case 2: return kindOfAdData[row]
        default: return "Unknown / Default"
        }
    }
    
}

extension FilterController: FilterRowDelegate {
    func showLocations() {
        let controller = AdOptionsController(optionType: .location, selectedIndex: locationIndex)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func askForLocation() {
        getUserLocation()
    }
    
    func showCategories() {
        let controller = AdOptionsController(optionType: .category, selectedIndex: categoryIndex)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tappedPicker(pickerType: FilterRowType) {
        var picker: UIPickerView
        switch pickerType {
        case .sorting:          picker = sortingPicker
        case .advertiserKind:   picker = advertiserPicker
        case .adKind:           picker = kindOfAdPicker
        default:                print("Default tappedpicker"); return
        }
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("done", for: .normal)
        doneButton.addTarget(self, action: #selector(handleAlertDone), for: .touchUpInside)
        doneButton.setTitleColor(.black, for: .normal)
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.view.heightAnchor.constraint(equalToConstant: 160).isActive = true
        alert.modalTransitionStyle = .coverVertical
        
        alert.view.addSubview(doneButton)
        doneButton.anchor(top: alert.view.topAnchor, right: alert.view.rightAnchor, paddingTop: 5, paddingRight: 15)
        
        alert.view.addSubview(picker)
        picker.anchor(left: alert.view.leftAnchor, bottom: alert.view.bottomAnchor, right: alert.view.rightAnchor, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 120)
        

        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleAlertDone() {
        dismiss(animated: true, completion: nil)
    }

}

extension FilterController: AdOptionsControllerDelegate {
    func didSelectCategory(withIndex index: Int) {
        categoryRow.optionText.text = Service.shared.categories[index]
        categoryIndex = index

        navigationController?.popViewController(animated: true)
    }
    
    func didSelectLocation(withIndex index: Int) {
        locationRow.optionText.text = Service.shared.locations[index]
        locationIndex = index
        
        navigationController?.popViewController(animated: true)
    }
}

extension FilterController: CLLocationManagerDelegate {
    func getUserLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("DEFAULT location in switch")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        location.fetchCityAndCountry { (city, country, error) in
            
            guard let city = city else { return }
            self.locationRow.optionText.text = city
            
        }
    }
}

