//
//  CoinDetailModel.swift
//  SwiftfulCrypto
//
//  Created by Mithilesh Chellappan on 30/10/2023.
//

import Foundation

// JSON Data
/*
 URL: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
*/


struct CoinDetail: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    var readableDescription: String? {
        return description?.en?.removeHTML
    }
    
//    enum CodingKeys: String, CodingKey {
//        case id, symbol, name, description, links
//        case blockTimeInMinutes = "block_time_in_minutes"
//        case hashingAlgorithm = "hashing_algorithm"
//    }
    
//    var readableDescription: String? {
//        return description?.en?.removingHTMLOccurances
//    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
}

struct Description: Codable {
    let en: String?
}
