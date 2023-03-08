//
//  HomeViewModel.swift
//  BNIMobile
//
//  Created by Naratama on 08/03/23.
//

import Foundation

class HomeViewModel{
    let homepageQuicklinkItems: [QuicklinkModel] = [QuicklinkModel(id: 1, title: "Transfer", image: "ic_optimize_cashflow"), QuicklinkModel(id: 2, title: "Top up & payment", image: "ic_mobile_add"), QuicklinkModel(id: 3, title: "TapCash", image: "ic_tapcash"), QuicklinkModel(id: 4, title: "QR Pay", image: "ic_qr_code")]
    
    let yourQuicklinkItems: [QuicklinkModel] = [QuicklinkModel(id: 1, title: "International Transfer", image: "ic_global_finance_euro"), QuicklinkModel(id: 2, title: "Pay Credit Card", image: "ic_credit_card"), QuicklinkModel(id: 3, title: "Bill Payment", image: "ic_receipt"), QuicklinkModel(id: 4, title: "Cardless", image: "ic_receipt"), QuicklinkModel(id: 4, title: "Cardless", image: "ic_receipt")]
}
