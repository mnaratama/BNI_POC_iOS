//
//  BaseResponse.swift
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

struct BaseResponse : Codable {
	let success : Bool?
	let responsestatuscode : Int?
	let message : String?
	let error : BNIError?
	let value : Value?
    let data : String?
    let userData: UserData?
    let accountName: String?

	enum CodingKeys: String, CodingKey {

		case success = "success"
		case responsestatuscode = "responsestatuscode"
		case message = "message"
		case error = "error"
		case value = "value"
        case data = "data"
        case userData = "userData"
        case accountName = "accountName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		responsestatuscode = try values.decodeIfPresent(Int.self, forKey: .responsestatuscode)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		error = try values.decodeIfPresent(BNIError.self, forKey: .error)
		value = try values.decodeIfPresent(Value.self, forKey: .value)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        userData = try values.decodeIfPresent(UserData.self, forKey: .userData)
        accountName = try values.decodeIfPresent(String.self, forKey: .accountName)
	}
    
    func encode(to encoder: Encoder) throws {
        
    }
}
