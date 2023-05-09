//
//  ContentView.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var messages: [Message] = []
    @State private var navigateToMessageCenter = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var isLoading = false
    
    private var messageService = MessageService()
    
    
    var body: some View {
        NavigationView {
            VStack {
                Image("RoomsToGo")
                    .padding(.bottom, 30)
                
                Text("Message Center")
                    .font(.custom("Poppins-Regular", size: 24))
                    .padding(.bottom, 20)
                
                
                Text("Enter your email to search for your messages:")
                    .multilineTextAlignment(.center)
                    .font(.custom("Poppins-Regular", size: 16))
                
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                Button(action: searchButtonTapped) {
                    Text("Search")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0, green: 79/255, blue: 181/255))  //#004FB5
                        .cornerRadius(40)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .padding(.horizontal, 20)
                
                
                if isLoading {
                    ProgressView()
                        .padding(.top, 20)
                }
                
                
            
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
    
    private func searchButtonTapped() {
        // Validate email address
        if email.isValidEmail {
            isLoading = true
            
            // Make the API request
            fetchData(for: email)
        } else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Please enter a valid email address."
        }
    }
    
    
    private func fetchData(for email: String) {
            isLoading = true
            messageService.fetchData(for: email) { [self] result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let messages):
                        self.messages = messages
                        self.navigateToMessageCenter = true
                    case .failure(let error):
                        // Handle the error, for example, by showing an alert
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

