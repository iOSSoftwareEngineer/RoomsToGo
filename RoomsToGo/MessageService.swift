//
//  MessageService.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation


// Fetches messages from a server.
struct MessageService {
    
    // The base URL for the API endpoint.
    private let baseURL = "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/"

    
    // Asychronously fetch data for the given email address
    // The completion handler takes a Result type, which represents either a success with an array of Message objects or a failure with an Error.
    func fetchData(for email: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        // Combine the base URL with the email to create the full URL for the request.
        let urlString = baseURL + email

        // Try to create a URL object from the string. If this fails, call the completion handler with an error and return.
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        // Create a data task with the URL. This sends a request to the server and then runs the closure when it receives a response.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // If an error occurred, print the error's description and call the completion handler with the error, then return.
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            // If no data was received (the server's response was empty), print a message and call the completion handler with an error, then return.
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }

            // Try to decode the data as a dictionary. If the dictionary has a non-empty string for the key "Error" or "Error:", call the completion handler with an error and return.
            if let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = (responseDict["Error"] as? String ?? responseDict["Error:"] as? String), !errorMessage.isEmpty {
                completion(.failure(NSError(domain: errorMessage, code: -3, userInfo: nil)))
            } else {
                // Try to decode the data as an array of Message objects. If this succeeds, call the completion handler with the array of messages.
                do {
                    let messages = try JSONDecoder().decode([Message].self, from: data)
                    completion(.success(messages))
                } catch {
                    // If decoding the data as an array of Message objects fails, print the received data and the error's description, then call the completion handler with the error.
                    print("Received data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF-8 string")")
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        // Start the data task. Until this point, the task has been set up but not executed.
        task.resume()
    }
}
