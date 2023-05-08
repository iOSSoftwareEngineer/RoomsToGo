//
//  APIResponse.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation

struct APIResponse: Codable {
    let messages: [Message]?
    let error: String?
}

