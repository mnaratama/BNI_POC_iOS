//
//  Point.swift
//  BNIMobile
//
//  Created by admin on 09/03/23.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let point = try? JSONDecoder().decode(Point.self, from: jsonData)

import Foundation

// MARK: - Point
struct Point: Codable {
    let cif: String
    let pointBalance: Int
}
