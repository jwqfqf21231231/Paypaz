//
//  CountryListTable.swift
//  Paypaz
//
//  Created by mac on 30/07/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import UIKit
enum TypeOfPicker{
    case phoneNumber
    case country
    case city
    case religion
}
class CountryListTable: UIViewController {
    var countries: [String] = []
    
    var religionList = ["Atheism/Agnosticism","Bahá'í","Buddhism","Christianity","Confucianism","Druze","Gnosticism","Hinduism","Islam","Jainism","Judaism","Rastafarianism","Shinto","Sikhism","Taoism","Zoroastrianism"]
    var countryList = [CountiesWithPhoneModel]()
    var cityFilterList = [CityCodable]()
    var cityList = [CityCodable]()
    var type = TypeOfPicker.phoneNumber
    var religionFilter = [String]()
    @IBOutlet weak var countrytable:UITableView!{
        didSet{
            self.countrytable.delegate = self
            self.countrytable.dataSource = self
        }
    }
    @IBOutlet weak var heading_lbl : UILabel!
    @IBOutlet var searchBar: UISearchBar!
    var countryID : ((_ id:String,_ name:String, _ code:String) -> Void)?
    var filterdata = [CountiesWithPhoneModel]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = self.getDataFormFile()
        self.countrytable.separatorStyle = .none
        searchBar.delegate = self
        
        if type == .city{
            heading_lbl.text = "Choose State"
            heading_lbl.textAlignment = .center
            cityFilterList = cityList
            self.countrytable.reloadData()
        }
        else if type == .religion{
            heading_lbl.text = "Choose your Religion"
            heading_lbl.textAlignment = .center
            religionFilter = religionList
            self.countrytable.reloadData()
        }
        else{
            heading_lbl.text = "Select a country"
            if data.1 == ""{
                countryList = data.0
                filterdata = countryList
                self.countrytable.reloadData()
            }
        }
    }
}

extension CountryListTable:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .city{
            return cityFilterList.count
        }
        else if type == .religion{
            return religionFilter.count
        }
        else{
            return filterdata.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .city {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as? CityCell else {
                return CountryCell()
            }
            cell.cityNameLbl.text = cityFilterList[indexPath.row].name ?? ""
            return cell
        }
        else if  type == .religion{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as? CityCell else {
                return CountryCell()
            }
            cell.cityNameLbl.text = religionFilter[indexPath.row]//[indexPath.row] ?? ""
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as? CountryCell else {
                return CountryCell()
            }
            cell.countryNameLbl.text = filterdata[indexPath.row].countryName
            cell.flag.image = UIImage.init(named: filterdata[indexPath.row].code ?? "")
            cell.code.isHidden = type == .phoneNumber ? false : true
            cell.code.text = filterdata[indexPath.row].dial_code
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .city{
            countryID?(cityFilterList[indexPath.row].name ?? "", "", "")
        }
        else if type == .religion{
            countryID?(religionFilter[indexPath.row], "","")
        }
        else{
            if type == .phoneNumber{
                countryID?(filterdata[indexPath.row].dial_code ?? "", filterdata[indexPath.row].countryName ?? "", filterdata[indexPath.row].code ?? "")
            }
            else{
                countryID?(filterdata[indexPath.row].countryName ?? "", filterdata[indexPath.row].code ?? "", "")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.view.endEditing(true)
        if type == .city{
            self.cityFilterList = self.cityList
        }
        else if type == .religion{
            self.religionFilter = self.religionList
        }
        else{
            self.filterdata = self.countryList
        }
        self.countrytable.reloadData()
        self.searchBar.text = ""
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if type == .city{
            cityFilterList = searchText.isEmpty ? cityList : cityList.filter { ($0.name ?? "").contains(searchText)}
        }
        else if type == .religion{
            religionFilter = searchText.isEmpty ? religionList : religionList.filter { ($0).contains(searchText)}
        }
        else{
            filterdata = searchText.isEmpty ? countryList : countryList.filter { ($0.countryName ?? "").contains(searchText)}
        }
        countrytable.reloadData()
    }
}
  
class CountryCell: UITableViewCell {
    @IBOutlet weak var countryNameLbl:UILabel!
    @IBOutlet weak var flag:UIImageView!
    @IBOutlet weak var code:UILabel!
}
class CityCell: UITableViewCell {
    @IBOutlet weak var cityNameLbl:UILabel!
 
}

