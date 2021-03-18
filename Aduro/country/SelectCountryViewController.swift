//
//  SelectCountryViewController.swift
//  Eptah
//
//  Created by Work on 12/07/2019.
//  Copyright © 2019 Work. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireImage
//import SwiftyGif


protocol SelectCountryViewControllerDelegate {
    func didSelectCuontry(country: Country)
}

//extension SelectCountryViewController :SwiftyGifDelegate {
////    func gifDidStop(sender: UIImageView) {
////        logoAnimationView.isHidden = true
////    }
//}

class SelectCountryViewController: UIViewController {

    // MARK: - Variables & Constants

    @IBOutlet weak var searchTextField: COUITextField!
    @IBOutlet weak var currentCountryLabel: UILabel!
    @IBOutlet weak var selectedCountryImageView: UIImageView!
    @IBOutlet weak var selectedCountryLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var selectCountryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var delegate: SelectCountryViewControllerDelegate?
    var dataSource = [Country]()
    var tableDataSource = [String:[Country]]()
    var tableSearchDataSource = [String:[Country]]()
    var sectionHeaders = [String]()
    var searchSectionHeaders = [String]()
    var selectedCountry: Country? = nil
//    let logoAnimationView = LogoAnimationView()
    
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(logoAnimationView)
//        logoAnimationView.pinEdgesToSuperView()
//        logoAnimationView.logoGifImageView.delegate = self
//        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        self.tableView.tableFooterView = UIView()
        
        searchTextField.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
        searchTextField.textFieldDelegate = self

        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        logoAnimationView.logoGifImageView.startAnimatingGif()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let country = selectedCountry {
            delegate?.didSelectCuontry(country: country)
        }
    }

    // MARK: - IBActions

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func textFieldEditingDidChange() {
        search()
    }
    
    // MARK: - Private Methods

    func loadData() {
        
        tableDataSource.removeAll()
        sectionHeaders.removeAll()
        
        Country.laodData { (data) in
            
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//                countryCode="DK"
                if let index = data.firstIndex(where: {$0.code == "DK"}) {
                    self.currentCountryLabel.text = data[index].name
                  //  self.currentLocationFlagImageView.af_setImage(withURL: URL(string: data[index].image)!)
                    
                    self.selectedCountryLabel.text = data[index].name
                    self.selectedCountryImageView.af_setImage(withURL: URL(string: data[index].image)!)
                    self.selectedCountry = data[index]
                }
            }
            
            self.dataSource = data
            
            for country in self.dataSource  {
                let key = (country.name.prefix(1)).uppercased()
                
                if var array = self.tableDataSource[key] {
                    array.append(country)
                    self.tableDataSource.updateValue(array, forKey: key)
                    
                } else {
                    self.tableDataSource.updateValue([country], forKey: key)
                }
                
                if !(self.sectionHeaders.contains(key)) {
                    self.sectionHeaders.append(key)
                }
                
            }
            
            self.sectionHeaders.sort()
            
            print(self.tableDataSource)
            
            self.tableView.reloadData()
        }
    }
    
    private func search() {
        let searchText = searchTextField.text!.lowercased()
        tableSearchDataSource.removeAll()
        searchSectionHeaders.removeAll()
        
        var tempData = [Country]()
        
        dataSource.forEach { (venue) in
            
            if venue.name.count >= searchText.count {
                let venuePrefix = venue.name.lowercased().prefix(searchText.count)
                
                if venuePrefix == searchText {
                    tempData.append(venue)
                }
            }
        }
        
        for country in tempData  {
            let key = (country.name.prefix(1)).uppercased()
            
            if var array = self.tableSearchDataSource[key] {
                array.append(country)
                self.tableSearchDataSource.updateValue(array, forKey: key)
                
            } else {
                self.tableSearchDataSource.updateValue([country], forKey: key)
            }
            
            if !(self.searchSectionHeaders.contains(key)) {
                self.searchSectionHeaders.append(key)
            }
        }
        
        self.searchSectionHeaders.sort()
        
        
        tableView.reloadData()
    }
    
    
}

extension SelectCountryViewController: UITableViewDelegate, UITableViewDataSource, COUITextFieldDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchTextField.text!.isEmpty {
            return sectionHeaders.count
        }
        
        return searchSectionHeaders.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0,y:0, width: tableView.frame.width, height: 60))
        let label = UILabel(frame: CGRect(x:30, y:0, width: view.frame.width, height: view.frame.height))
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if searchTextField.text!.isEmpty {
            label.text = sectionHeaders[section]
            
        } else {
            label.text = searchSectionHeaders[section]
        }
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchTextField.text!.isEmpty {
            return tableDataSource[sectionHeaders[section]]?.count ?? 0
        }
        
        return tableSearchDataSource[searchSectionHeaders[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CountryTableViewCell.cellForTableView(tableView: tableView)
        var data = tableDataSource[sectionHeaders[indexPath.section]]?[indexPath.row]
        
        if !searchTextField.text!.isEmpty {
            data = tableSearchDataSource[searchSectionHeaders[indexPath.section]]?[indexPath.row]
        }
        
        cell.nameLabel.text = data?.name ?? ""

        if let url = URL(string: data?.image ?? "") {
            
            cell.flagImageView.af_setImage(withURL:url, placeholderImage: nil, filter: nil,  imageTransition: .crossDissolve(0.1), runImageTransitionIfCached: false, completion: {response in
            })
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchTextField.text!.isEmpty {
            selectedCountry = (tableDataSource[sectionHeaders[indexPath.section]]?[indexPath.row])!
        
        } else {
            selectedCountry = (tableSearchDataSource[searchSectionHeaders[indexPath.section]]?[indexPath.row])!
        }

        selectedCountryLabel.text = selectedCountry?.name
        selectedCountryImageView.af_setImage(withURL: URL(string: selectedCountry!.image)!)
        currentCountryLabel.text = selectedCountry?.name
//        delegate?.didSelectCuontry(country: selectedCountry!)
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - COUITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        search()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
}
