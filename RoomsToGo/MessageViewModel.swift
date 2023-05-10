//
//  MessageViewModel.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/9/23.
//

import Foundation

class MessageViewModel: ObservableObject {
    // Observable properties
    @Published var messages: [Message] = []
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var navigateToMessageCenter: Bool = false

    // The MessageService is responsible for fetching the messages.
    private var messageService = MessageService()
    
    
    // Fetch data for the given email address
    func fetchData(for email: String) {
        // Validate the email address. If it is valid, fetchData() is called. Otherwise, an alert is shown.
        if email.isValidEmail {
            isLoading = true
            messageService.fetchData(for: email) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let messages):
                        // If the fetch was successful, save the messages and trigger navigation to the MessageCenter.
                        self?.messages = messages
                        self?.navigateToMessageCenter = true
                    case .failure(let error):
                        // If the fetch failed, show an alert with the error message.
                        self?.showAlert = true
                        self?.alertTitle = "Error"
                        self?.alertMessage = error.localizedDescription
                    }
                }
            }
        } else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Please enter a valid email address."
        }
    }
}

