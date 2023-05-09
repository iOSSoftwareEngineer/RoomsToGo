//
//  APIResponse.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation

// Represents the response returned from the API.
// Since it conforms to the Codable protocol, it can be used to decode data from JSON and encode data as JSON.
struct APIResponse: Codable {
    
    // An array of Message objects.
    // This property is an optional since the API may not always return a list of messages.
    // For example, if the user has no messages or an error occurs, this property could be nil.
    let messages: [Message]?
    
    // Holds a string describing an error that occurred.
    // This property is an optional; if the request is successful, there won't be any error.
    // If the API returns an error, the error message will be stored in this property.
    let error: String?
}


