

import Foundation
struct AccountBalanceBaseModel : Codable {
	let message : String?
	let coreJournal : String?
	let customHeader : String?
	let content : Content?

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case coreJournal = "coreJournal"
		case customHeader = "customHeader"
		case content = "content"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		coreJournal = try values.decodeIfPresent(String.self, forKey: .coreJournal)
		customHeader = try values.decodeIfPresent(String.self, forKey: .customHeader)
		content = try values.decodeIfPresent(Content.self, forKey: .content)
	}

}
