//
//  Message.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation


struct Message: Codable, Identifiable {
    
    // An id for the message, automatically generated using UUID
    let id = UUID()
    
    // The name of the sender of the message
    let name: String
    
    // The date the message was sent
    let date: Date
    
    // The message body text
    let message: String

    // Coding keys for decoding the JSON object
    private enum CodingKeys: String, CodingKey {
        case name, date, message
    }

    // Custom initializer to decode the JSON object
    init(from decoder: Decoder) throws {
        
        // Retrieve the coding container keyed by the coding keys
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the name and message values from the container
        name    = try container.decode(String.self, forKey: .name)
        message = try container.decode(String.self, forKey: .message)

        // Decode the date value from the container as a string
        let dateString = try container.decode(String.self, forKey: .date)
        
        // Create a date formatter to parse the date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        
        // Attempt to parse the date string into a Date object using the formatter
        guard let dateValue = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        date = dateValue
    }
    
    // Overload the equality operator for comparing messages
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    // Custom implementation of the hash function for storing messages in a set or dictionary
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

