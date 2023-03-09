//
//  AddPoint.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let addPoint = try? JSONDecoder().decode(AddPoint.self, from: jsonData)

import Foundation

// MARK: - AddPoint
struct AddPoint: Codable {
    let cif: String
    let value: Int
}
