//
//  ViewController.swift
//  CountryCodePicker
//
//  Created by Raja on 21/05/18.
//  Copyright © 2018 Raja. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CountryCodesDelegate {
    @IBOutlet weak var statusLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func pickCountryCodeBthHandler(_ sender: Any) {
        let vc = CountryCodesViewController();
        vc.delegate = self
        self.present(vc, animated: true, completion: nil);
    }
    
    
    func didSelectCountryCode(_ countryName: String, dialingCode: String) {
        self.statusLbl.text = dialingCode+"\n"+countryName
    }
}

