//
//  Message.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation


struct Message: Codable, Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let message: String

    private enum CodingKeys: String, CodingKey {
        case name, date, message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        message = try container.decode(String.self, forKey: .message)

        let dateString = try container.decode(String.self, forKey: .date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let dateValue = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        date = dateValue
    }
    
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
