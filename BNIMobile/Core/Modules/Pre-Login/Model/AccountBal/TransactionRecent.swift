

import Foundation
struct TransactionRecent : Codable {
	let transactionType : String?
	let amount : Double?
	let createdDate : String?

	enum CodingKeys: String, CodingKey {

		case transactionType = "transactionType"
		case amount = "amount"
		case createdDate = "createdDate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		transactionType = try values.decodeIfPresent(String.self, forKey: .transactionType)
		amount = try values.decodeIfPresent(Double.self, forKey: .amount)
		createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
	}

}
