

import Foundation
struct Content : Codable {
	let account_num : String?
	let name : String?
	let current_balance : Int?
	let available_balance : Int?
	let product_type : String?

	enum CodingKeys: String, CodingKey {

		case account_num = "account_num"
		case name = "name"
		case current_balance = "current_balance"
		case available_balance = "available_balance"
		case product_type = "product_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		account_num = try values.decodeIfPresent(String.self, forKey: .account_num)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		current_balance = try values.decodeIfPresent(Int.self, forKey: .current_balance)
		available_balance = try values.decodeIfPresent(Int.self, forKey: .available_balance)
		product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
	}

}
