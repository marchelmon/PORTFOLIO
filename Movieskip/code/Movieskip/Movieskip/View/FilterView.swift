//
//  FilterView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import UIKit

class FilterView: UIView {
    
    //MARK: - Properties
    
    var filter = FilterService.filter
        
    var minYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Min year"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var maxYearLabel: UILabel = {
        let label = UILabel()
        label.text = "Max year"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    var minYearValueLabel = UILabel()
    var maxYearValueLabel = UILabel()
    
    lazy var minYearSlider = createYearRangeSlider(minimumYearSpan: 0)
    lazy var maxYearSlider = createYearRangeSlider(minimumYearSpan: 5)
    
    let popularText: UILabel = {
        let label = UILabel()
        label.text = "Popular only"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var popularToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(handleTogglePopular), for: .touchUpInside)
        return toggle
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureUI()
        configureFilter()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleTogglePopular(sender: UISwitch) {
        filter.popular = sender.isOn
    }
    
    @objc func handleSliderChanged(sender: UISlider) {
        if sender == minYearSlider {
            minYearValueLabel.text = "\(Int(filter.minYear))"
            filter.minYear = sender.value
        } else {
            maxYearValueLabel.text = "\(Int(filter.maxYear))"
            filter.maxYear = sender.value
        }
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        
        let minYearStack = UIStackView(arrangedSubviews: [minYearLabel, minYearValueLabel])
        let maxYearStack = UIStackView(arrangedSubviews: [maxYearLabel, maxYearValueLabel])

        addSubview(minYearStack)
        minYearStack.centerX(inView: self)
        minYearStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        minYearValueLabel.anchor(right: minYearStack.rightAnchor)

        addSubview(minYearSlider)
        minYearSlider.anchor(top: minYearLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 30, paddingRight: 25)
        
        addSubview(maxYearStack)
        maxYearStack.centerX(inView: self)
        maxYearStack.anchor(top: minYearSlider.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        maxYearValueLabel.anchor(right: maxYearStack.rightAnchor)

        addSubview(maxYearSlider)
        maxYearSlider.anchor(top: maxYearStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 30, paddingRight: 25)
        
        let popularStack = UIStackView(arrangedSubviews: [popularText, popularToggle])
        
        addSubview(popularStack)
        popularStack.anchor(top: maxYearSlider.bottomAnchor, paddingTop: 30)
        
        popularText.anchor(left: leftAnchor, paddingLeft: 20)
        popularToggle.anchor(right: rightAnchor, paddingRight: 25)
        
    }
    
    func configureFilter() {

        minYearValueLabel.text = "\(Int(filter.minYear))"
        maxYearValueLabel.text = "\(Int(filter.maxYear))"

        minYearSlider.setValue(filter.minYear, animated: true)
        maxYearSlider.setValue(filter.maxYear, animated: true)
    
        popularToggle.setOn(filter.popular, animated: true)
        
    }
    
    func createYearRangeSlider(minimumYearSpan value: Float) -> UISlider  {
        let slider = UISlider()
        slider.minimumValue = 1950 + value
        slider.maximumValue = 2016 + value
        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
        return slider
    }
    
    
}



