//
//  ContentView.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//  Xcode Version 14.3 (14E222b)

import SwiftUI

// This ContentView struct is a SwiftUI View, and it is responsible for displaying the main UI of your app.
struct ContentView: View {
    // @State properties are used for mutable state that belongs to this specific view.
    // The SwiftUI framework will automatically watch for changes to these properties and will then re-render the view when they change.
    @State private var email: String = ""
    @State private var messages: [Message] = []
    @State private var navigateToMessageCenter = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var isLoading = false

    // The MessageService is responsible for fetching the messages.
    private var messageService = MessageService()

    
    // This is the body property, which is required for all SwiftUI views.
    // It defines the content and layout of the view.
    var body: some View {
        NavigationView {
            VStack {
                // This section sets up the image and the static texts.
                Image("RoomsToGo")
                    .padding(.bottom, 30)
                
                Text("Message Center")
                    .font(.custom("Poppins-Regular", size: 24))
                    .padding(.bottom, 20)
                
                
                Text("Enter your email to search for your messages")
                    .multilineTextAlignment(.center)
                    .font(.custom("Poppins-Regular", size: 16))
                
                
                // This is the TextField where the user can input their email.
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // This is the Search button. When pressed, it calls the searchButtonTapped() function.
                Button(action: searchButtonTapped) {
                    Text("Search")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0, green: 79/255, blue: 181/255))  //#004FB5
                        .cornerRadius(40)
                }
                // This alert is shown when showAlert is true.
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .padding(.horizontal, 20)
                
                // This ProgressView is shown when isLoading is true.
                if isLoading {
                    ProgressView()
                        .padding(.top, 20)
                }
                
                // This NavigationLink navigates to the MessageCenter view when navigateToMessageCenter is true.
                NavigationLink(
                    destination: MessageCenter(messages: messages.sorted(by: { $0.date > $1.date })),
                    isActive: $navigateToMessageCenter,
                    label: { EmptyView() }
                )
                
                Spacer()
            }
            .padding()
        }
    }

    
    // This function is called when the Search button is tapped.
    private func searchButtonTapped() {
        // Validate the email address. If it is valid, fetchData() is called. Otherwise, an alert is shown.
        if email.isValidEmail {
            isLoading = true
            fetchData(for: email)
        } else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Please enter a valid email address."
        }
    }
    
    
    // This function is responsible for fetching the data.
    // It calls the fetchData() function in the MessageService and updates the @State properties based on the result.
    private func fetchData(for email: String) {
        // Set the loading indicator to visible
        isLoading = true
        
        messageService.fetchData(for: email) { [self] result in
            // Switch to the main queue because we're going to be updating the UI.
            DispatchQueue.main.async {
                // Stop showing the loading indicator
                isLoading = false
                
                // Handle the result of the fetch operation.
                switch result {
                    case .success(let messages):
                        // If the fetch was successful, save the messages and trigger navigation to the MessageCenter.
                        self.messages = messages
                        self.navigateToMessageCenter = true
                    case .failure(let error):
                        // If the fetch failed, show an alert with the error message.
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                              let rootViewController = windowScene.windows.first?.rootViewController else {
                            fatalError("Unable to retrieve window scene or root view controller")
                        }

                        rootViewController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

            

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

