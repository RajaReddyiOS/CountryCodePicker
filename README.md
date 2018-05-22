# CountryCodePicker
* Add source folder on your project (drag and drop -> copy if need).
* Add piece of code 

        let viewController = CountryCodesViewController();
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil);
        
* Add delegates to your controller 

* You will get callBack Here along with country name and dial code

    func didSelectCountryCode(_ countryName: String, dialingCode: String) {
    
        print("Country Code: \(countryName), Dialing Code: (dialingCode)")
        
    }


