//
//  CountryCodes.swift
//  COGCONS
//
//  Created by Raja on 23/02/18.
//  Copyright © 2018 Cogcons. All rights reserved.
//

import Foundation

class CountryCodes:NSObject {

    static let sharedInstance = CountryCodes()
    override init() {
        super.init()
    }
    public func getAllCountryCodes() -> [Countries]? {
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                do {
                    let decodedCountries = try JSONDecoder().decode(CountryCodeModel.self, from: data)
                    return decodedCountries.countries
                } catch {
                    print(error)
                }
            } catch let error {
                print("can't convert exception: ",error)
            }
        }
        return nil
    }
}



