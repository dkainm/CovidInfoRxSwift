//
//  CountriesViewController.swift
//  covid info
//
//  Created by Alex Rudoi on 9/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class CountriesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        ApiManager.shared.getListOfCountries { [weak self] countries in
            
            if let countries = countries {
                self?.countries = countries
                DispatchQueue.main.async {
                    self?.setup()
                }
            } else {
                UIAlertController.presentOkAlert(
                    title: "Something went wrong",
                    message: "Check your internet connection or restart the app",
                    style: .alert)
            }
            
        }
    }

    private func setup() {
        let objArray: Observable<[Country]> = Observable.just(countries)
        
        objArray.bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, country, cell in
            cell.textLabel?.text = country.name
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Country.self).subscribe { [weak self] country in
            let countryDataVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryDataViewController") as! CountryDataViewController
            countryDataVC.country = country.element
            self?.navigationController?.pushViewController(countryDataVC, animated: true)
        }.disposed(by: disposeBag)

    }

}

