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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rooms to Go")
                    .font(.custom("Poppins", size: 24))
                    .padding(.bottom, 20)
                
                Text("Enter your email address:")
                    .font(.custom("Poppins", size: 16))
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                Button(action: searchButtonTapped) {
                    Text("Search")
                        .font(.custom("Poppins", size: 16))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0, green: 79/255, blue: 181/255))
                        .cornerRadius(40)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .padding(.horizontal, 20)
                
                // Add this NavigationLink below the Button
                NavigationLink(destination: MessageCenter(messages: messages.sorted(by: { $0.date > $1.date })), isActive: $navigateToMessageCenter) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    private func searchButtonTapped() {
        // Validate email address
        if isValidEmail(email) {
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
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let errorMessage = responseDict?["Error"] as? String, !errorMessage.isEmpty {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let messages = try JSONDecoder().decode([Message].self, from: data)
                    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.messages = messages
                        self.navigateToMessageCenter = true
                    }
                }
            } catch {
                print("Received data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF-8 string")")
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

            

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

