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
