//
//  Error.swift
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
struct BNIError : Codable {
	let type : String?
	let code : String?
	let message : String?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case code = "code"
		case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		code = try values.decodeIfPresent(String.self, forKey: .code)
		message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
