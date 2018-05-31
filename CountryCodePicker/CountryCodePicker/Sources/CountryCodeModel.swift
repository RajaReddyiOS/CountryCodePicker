//
//  CountryCodeModel.swift
//  CountryCodePicker
//
//  Created by Raja on 21/05/18.
//  Copyright © 2018 Raja. All rights reserved.
//

import Foundation


struct Countries:Codable {
    var name = String();
    var english_name = String();
    var name_code = String();
    var phone_code = String();
}

struct CountryCodeModel:Codable {
    var countries = [Countries]();
}
