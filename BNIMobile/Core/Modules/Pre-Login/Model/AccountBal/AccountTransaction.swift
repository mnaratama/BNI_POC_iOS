

import Foundation

struct AccountTransaction : Codable {
	let success : Bool?
	let status : Int?
	let message : String?
	let productType : String?
	let currentBalance : Double?
	let transactions : [TransactionRecent]?
	let error : String?

	enum CodingKeys: String, CodingKey {

		case success = "success"
		case status = "status"
		case message = "message"
		case productType = "productType"
		case currentBalance = "currentBalance"
		case transactions = "transactions"
		case error = "error"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		status = try values.decodeIfPresent(Int.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		productType = try values.decodeIfPresent(String.self, forKey: .productType)
		currentBalance = try values.decodeIfPresent(Double.self, forKey: .currentBalance)
		transactions = try values.decodeIfPresent([TransactionRecent].self, forKey: .transactions)
		error = try values.decodeIfPresent(String.self, forKey: .error)
	}

}
