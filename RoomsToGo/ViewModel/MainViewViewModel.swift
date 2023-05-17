//
//  MessageViewModel.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/9/23.
//

import Foundation

// MessageViewModel class which will be the ViewModel in MVVM architecture.
class MainViewViewModel: ObservableObject {

    // @Published properties are observable properties.
    // SwiftUI will automatically watch for changes to these properties and will then re-render the views that depend on them when they change.

    // Messages that are fetched from the API.
    @Published var messages: [Message] = []

    // Boolean to control whether an alert is shown.
    @Published var showAlert: Bool = false

    // The title and message for the alert.
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    // Boolean to control whether a loading indicator is shown.
    @Published var isLoading: Bool = false

    // Boolean to control navigation to the MessageCenter view.
    @Published var navigateToMessageCenter: Bool = false
    
    // Boolean to determine whether the Search button is enabled/disabled
    @Published var isSearchButtonEnabled = true
    

    // The MessageService is responsible for fetching the messages.
    private var messageService = MessageService()
    
    // Fetch data for the given email address.
    // This method is called when the Search button is tapped.
    func fetchData(for email: String) {
        
        // Validate the email address. If it is valid, fetchData() in the MessageService is called. Otherwise, an alert is shown.
        if email.isValidEmail {
            
            // Start showing the loading indicator.
            isLoading = true
            
            //Disable the search button until the result has been returned.
            isSearchButtonEnabled = false

            // Call fetchData() in the MessageService, passing in the email address and a closure to handle the result.
            messageService.fetchData(for: email) { [weak self] result in
                // Switch to the main queue because we're going to be updating the UI.
                DispatchQueue.main.async {
                    // Stop showing the loading indicator.
                    self?.isLoading = false
                    self?.isSearchButtonEnabled = true

                    // Handle the result of the fetch operation.
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
            // If the email address is not valid, show an alert.
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Please enter a valid email address."
        }
    }
}
