//
//  Currency.swift
//  currency
//
//  Created by Eiyub Bodur on 10/06/23.
//

import Foundation
import Alamofire


struct Currency: Codable {
    var success: Bool
    var base: String
    var date: String
    var rates = [String: Double]()
}

func apiRequest(url: String) async throws -> Currency {
    return try await withCheckedThrowingContinuation { continuation in
        var headers = HTTPHeaders()
        headers.add(name: "apikey", value: "jjA4XKT6Y9NR4pH1OM59Ll6XkHAiZ7Vd")
        
        Session.default.request(url, headers: headers).responseDecodable(of: Currency.self) { response in
            continuation.resume(with: response.result)
        }
    }
}
