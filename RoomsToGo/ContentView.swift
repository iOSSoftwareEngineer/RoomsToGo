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
        if isValidEmail(email) {
            isLoading = true
            
            // Make the API request
            fetchData(for: email)
        } else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Please enter a valid email address."
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    private func fetchData(for email: String) {
        let baseURL = "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/"
        let urlString = baseURL + email
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            self.isLoading = false
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorMessage = (responseDict["Error"] as? String ?? responseDict["Error:"] as? String), !errorMessage.isEmpty {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let rootViewController = windowScene.windows.first?.rootViewController else {
                        fatalError("Unable to retrieve window scene or root view controller")
                    }

                    rootViewController.present(alert, animated: true, completion: nil)
                }
            } else {
                do {
                    let messages = try JSONDecoder().decode([Message].self, from: data)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.messages = messages
                        self.navigateToMessageCenter = true
                    }
                } catch {
                    print("Received data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF-8 string")")
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

}

            

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

