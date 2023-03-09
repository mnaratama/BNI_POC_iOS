//
//  HomeModel.swift
//  BNIMobile
//
//  Created by Naratama on 08/03/23.
//

import Foundation

struct QuicklinkModel {
    let id: Int?
    let title: String?
    let image: String?
    
    init(id: Int?, title: String?, image: String?) {
        self.id = id
        self.title = title
        self.image = image
    }
}

//Homepage
struct AccountListBaseModel : Codable {
    let success : Bool?
    let status : Int?
    let message : String?
    let accounts : [Accounts]?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case status = "status"
        case message = "message"
        case accounts = "accounts"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        accounts = try values.decodeIfPresent([Accounts].self, forKey: .accounts)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct Accounts : Codable {
    let accountNo : String?
    let currentBalance : Double?
    let productType : String?

    enum CodingKeys: String, CodingKey {

        case accountNo = "accountNo"
        case currentBalance = "currentBalance"
        case productType = "productType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountNo = try values.decodeIfPresent(String.self, forKey: .accountNo)
        currentBalance = try values.decodeIfPresent(Double.self, forKey: .currentBalance)
        productType = try values.decodeIfPresent(String.self, forKey: .productType)
    }

}

//AccountPage
struct TransactionBaseModel : Codable {
    let success : Bool?
    let status : Int?
    let message : String?
    let transactions : [Transactions]?
    let error : String?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case status = "status"
        case message = "message"
        case transactions = "transactions"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        transactions = try values.decodeIfPresent([Transactions].self, forKey: .transactions)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct Transactions : Codable {
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
