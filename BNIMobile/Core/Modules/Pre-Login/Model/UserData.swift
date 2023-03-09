//
//  UserData.swift
//  BNIMobile
/*
 * Licensed Materials - Property of IBM
 * Copyright (C) 2023 IBM Corp. All Rights Reserved.
 *
 * IMPORTANT: This IBM software is supplied to you by IBM
 * Corp. (""IBM"") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import Foundation
struct UserData : Codable {
    let accountname : String?
    let acid : String?
    let mobilenumber : String?
    let bindidmobilenumber : String?
    let accountno : String?
    let cif : String?

    enum CodingKeys: String, CodingKey {

        case accountname = "accountname"
        case acid = "acid"
        case mobilenumber = "mobilenumber"
        case bindidmobilenumber = "bindidmobilenumber"
        case accountno = "accountno"
        case cif = "cif"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountname = try values.decodeIfPresent(String.self, forKey: .accountname)
        acid = try values.decodeIfPresent(String.self, forKey: .acid)
        mobilenumber = try values.decodeIfPresent(String.self, forKey: .mobilenumber)
        bindidmobilenumber = try values.decodeIfPresent(String.self, forKey: .bindidmobilenumber)
        accountno = try values.decodeIfPresent(String.self, forKey: .accountno)
        cif = try values.decodeIfPresent(String.self, forKey: .cif)
    }

}
