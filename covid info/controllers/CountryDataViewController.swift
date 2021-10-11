//
//  CountryDataViewController.swift
//  covid info
//
//  Created by Alex Rudoi on 11/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class CountryDataViewController: UIViewController {
    
    @IBOutlet private weak var countryNameLabel: UILabel!
    
    @IBOutlet private weak var confirmedLabel: UILabel!
    @IBOutlet private weak var recoveredLabel: UILabel!
    @IBOutlet private weak var deathsLabel: UILabel!
    
    @IBOutlet private weak var lastUpdateDateLabel: UILabel!
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        guard country.code != nil else {
            noInfoForCountry()
            return
        }
        
        ApiManager.shared.getCountryData(country: country) { [weak self] data in
        
            DispatchQueue.main.async {
                if let data = data {
                    self?.setup(countryData: data)
                } else {
                    self?.noInfoForCountry()
                }
            }
            
        }
    }
    
    private func setup(countryData: CountryData) {
        countryNameLabel.text = countryData.country
        confirmedLabel.text = "\(countryData.confirmed.formatUsingAbbrevation())"
        recoveredLabel.text = "\(countryData.recovered.formatUsingAbbrevation())"
        deathsLabel.text = "\(countryData.deaths.formatUsingAbbrevation())"
        if let lastUpdate = countryData.lastUpdate {
            lastUpdateDateLabel.text = "Last update: \(lastUpdate.unwrapStringDate(format: .simple))"
        }
        
        countryNameLabel.backgroundColor = .clear
        confirmedLabel.backgroundColor = .clear
        recoveredLabel.backgroundColor = .clear
        deathsLabel.backgroundColor = .clear
        lastUpdateDateLabel.backgroundColor = .clear
    }
    
    private func noInfoForCountry() {
        UIAlertController.presentOkAlert(
            title: "No information for country \(country.name)",
            message: nil,
            style: .alert) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
    }

}
