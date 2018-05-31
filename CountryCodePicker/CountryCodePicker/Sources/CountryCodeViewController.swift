//
//  CountryCodeViewController.swift
//  CountryCodePicker
//
//  Created by Raja on 21/05/18.
//  Copyright © 2018 Raja. All rights reserved.
//

import UIKit

protocol CountryCodesDelegate {
    func didSelectCountryCode(_ countryName:String,dialingCode:String)
}

class CountryCodesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {    
    
    fileprivate var scrollContentOffset = CGPoint()
    fileprivate var isScrollingDown = false
    fileprivate var isScrollingUp = false
    fileprivate var searchBarTopConstraint:NSLayoutConstraint?
    fileprivate let cellIdentifier = "cellIdentifier"
    fileprivate var selectedCountryCode = String()
    fileprivate var filteredCountryCodesArray = [Countries]()
    fileprivate var countryCodesArray = [Countries]()
    fileprivate var isSearchResults = Bool()
    
    var timer = Timer()
    var delegate:CountryCodesDelegate?
    
    let tableView:UITableView = {
        let tv = UITableView(frame: .zero, style: UITableViewStyle.plain)
        tv.estimatedRowHeight = 200
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableViewAutomaticDimension
        return tv
    }()
    
    let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Your Country"
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        return lbl
    }()
    
    let searchBar:UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = UIColor.black
        return sb
    }()
    
    
    let customNavBar:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let backButton:UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), for: UIControlState.normal)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let array = CountryCodes.sharedInstance.getAllCountryCodes() else {return}
        countryCodesArray = array
        self.setupViews()
    }
    
    func setupViews() {
        self.setupNavBar()
        self.setupSearchBar()
        self.setupTableView()
        self.setupBackBtn()
    }
    
    func setupSearchBar() {
        self.view.addSubview(searchBar)
        
        [self.searchBar.leftAnchor.constraint(equalTo: self.customNavBar.leftAnchor, constant: 0),
         self.searchBar.rightAnchor.constraint(equalTo: self.customNavBar.rightAnchor, constant: 0),
         self.searchBar.heightAnchor.constraint(equalToConstant: 44)].forEach { (constraints) in
            constraints.isActive = true
        }
    
        searchBarTopConstraint = self.searchBar.topAnchor.constraint(equalTo: self.customNavBar.bottomAnchor, constant: 0)
        searchBarTopConstraint?.isActive = true

        self.view.bringSubview(toFront: customNavBar)
        self.searchBar.delegate = self
    }
    
    func setupBackBtn() {
        self.customNavBar.addSubview(self.backButton)
        self.backButton.leftAnchor.constraint(equalTo: self.customNavBar.leftAnchor, constant: 12).isActive = true
        self.backButton.centerYAnchor.constraint(equalTo: self.customNavBar.centerYAnchor).isActive = true
        self.backButton.addTarget(self, action: #selector(self.backBtnHandler), for: UIControlEvents.touchUpInside)
    }
    
    @objc fileprivate func backBtnHandler() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupNavBar() {
        self.view.addSubview(self.customNavBar)
        if #available(iOS 11.0, *) {
            [self.customNavBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
             self.customNavBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
             self.customNavBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
             self.customNavBar.heightAnchor.constraint(equalToConstant: 45)].forEach { (constraints) in
                constraints.isActive = true
            }
        } else {
            [self.customNavBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
             self.customNavBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
             self.customNavBar.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
             self.customNavBar.heightAnchor.constraint(equalToConstant: 45)].forEach { (constraints) in
                constraints.isActive = true
            }
        }
        self.customNavBar.addSubview(self.titleLbl)
        self.titleLbl.centerXAnchor.constraint(equalTo: self.customNavBar.centerXAnchor).isActive = true
        self.titleLbl.centerYAnchor.constraint(equalTo: self.customNavBar.centerYAnchor).isActive = true
    }
    
    fileprivate func setupTableView() {
        self.view.addSubview(self.tableView)
        if #available(iOS 11.0, *) {
            [self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0),
             self.tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
             self.tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
             self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)].forEach { (con) in
                con.isActive = true
            }
        } else {
            [self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 0),
             self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
             self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
             self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)].forEach { (con) in
                con.isActive = true
            }
        }
        self.tableView.register(CountryCodeCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearchResults {
            return self.filteredCountryCodesArray.count
        }
        return countryCodesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! CountryCodeCell
        if self.isSearchResults {
            if filteredCountryCodesArray.count > indexPath.row {
                if filteredCountryCodesArray[indexPath.row].phone_code == self.selectedCountryCode {
                    cell.accessoryType = .checkmark
                }else {
                    cell.accessoryType = .none
                }
                cell.countryCodelModelObj = filteredCountryCodesArray[indexPath.row]
            }
        }else {
            if countryCodesArray.count > indexPath.row {
                if countryCodesArray[indexPath.row].phone_code == self.selectedCountryCode {
                    cell.accessoryType = .checkmark
                }else {
                    cell.accessoryType = .none
                }
                cell.countryCodelModelObj = countryCodesArray[indexPath.row]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            if self.isSearchResults {
                if self.filteredCountryCodesArray.count > indexPath.row {
                    delegate?.didSelectCountryCode(self.filteredCountryCodesArray[indexPath.row].name, dialingCode: self.filteredCountryCodesArray[indexPath.row].phone_code)
                    dismiss(animated: true, completion: nil);
                }
            }else {
                if countryCodesArray.count > indexPath.row {
                    delegate?.didSelectCountryCode(countryCodesArray[indexPath.row].name, dialingCode: countryCodesArray[indexPath.row].phone_code)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && !self.isSearchResults {
            let viewForHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
            viewForHeader.backgroundColor = UIColor.groupTableViewBackground
            return viewForHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && !self.isSearchResults {
            return 20
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            if self.scrollContentOffset.y < scrollView.contentOffset.y {
                if !self.isScrollingUp {
                    self.isScrollingUp = true
                    self.isScrollingDown = false
                    self.searchBarTopConstraint?.constant = -44
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }else if self.scrollContentOffset.y > scrollView.contentOffset.y {
                if !self.isScrollingDown {
                    self.isScrollingDown = true
                    self.isScrollingUp = false
                    self.searchBarTopConstraint?.constant = 0
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollview did scroll top")
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollContentOffset = scrollView.contentOffset
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search bar text: ",searchText)
        if let searchText = self.searchBar.text {
            if searchText.isBlank {
                self.isSearchResults = false
            }else {
                self.filteredCountryCodesArray.removeAll()
                let array = countryCodesArray.filter({$0.name.lowercased().contains(searchText.lowercased()) || $0.phone_code.lowercased().contains(searchText.lowercased())})
                print("array count: ",array.count)
                self.filteredCountryCodesArray = array
                self.isSearchResults = true
            }
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateSearchCountryCodes), userInfo: nil, repeats: false)
        }
    }
    
    @objc fileprivate func updateSearchCountryCodes() {
        self.timer.invalidate()
        self.tableView.reloadData()
    }
    
}


class CountryCodeCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let flagImageView:UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    fileprivate let countryNameLbl:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    fileprivate let dialingCodeLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.gray
        lbl.textAlignment = .right
        return lbl
    }()
    
    var countryCodelModelObj:Countries? {
        didSet {
            if let countryCodelModelObj = countryCodelModelObj {
                self.countryNameLbl.text = countryCodelModelObj.name
                self.dialingCodeLbl.text = countryCodelModelObj.phone_code
                let imageName = "flag_"+countryCodelModelObj.name.lowercased().replace(" ", "_")
                if let bundleUrl = Bundle.main.url(forResource: "CountryCodesAssets", withExtension: "bundle") {
                    if let bundle = Bundle(url: bundleUrl) {
                        let imagePath = bundle.path(forResource: imageName, ofType: "png")
                        let image = UIImage(contentsOfFile: imagePath ?? "")
                        if image == nil {
                            print("image name: ",imageName)
                        }
                        self.flagImageView.image = image
                    }
                }
            }
        }
    }
    
    func setupViews() {
        self.addSubview(self.flagImageView)
        self.flagImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 45, heightConstant: 30)
        self.addSubview(self.dialingCodeLbl)
        self.dialingCodeLbl.anchor(nil, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 0)
        self.dialingCodeLbl.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        
        self.dialingCodeLbl.anchorCenterYToSuperview()
        self.addSubview(countryNameLbl)
        self.countryNameLbl.anchor(self.topAnchor, left: self.flagImageView.rightAnchor, bottom: bottomAnchor, right: dialingCodeLbl.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }
}




