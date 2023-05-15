//
//  ContentView.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//  Xcode Version 14.3 (14E222b)

import SwiftUI

// The main screen
struct ContentView: View {
    
    // Stores the user's email
    // This property is initialized as an empty string and will be updated by the TextField view.
    @State private var email: String = ""
    
    //Stores whether the email field has focus
    @FocusState private var emailFocused: Bool
    
    // Stores an instance of the MessageViewModel.
    // SwiftUI will watch for changes to this object and will re-render the view when changes are detected.
    @ObservedObject var viewModel = MessageViewModel()

    // The body property defines the content and layout of the view.
    var body: some View {
        // Use a NavigationView to provide a navigation bar for the view.
        NavigationStack {
            // Use a VStack to arrange subviews vertically.
            VStack {
                // Display the "RoomsToGo" image at the top of the view.
                Image("RoomsToGo")
                    // Add some padding below the image.
                    .padding(.bottom, 30)
                
                // Display a text view with the title "Message Center".
                Text("Message Center")
                    // Customize the font of the text view.
                    .font(.custom(Constants.defaultFont, size: Constants.mainScreenHeaderFontSize))
                    // Add some padding below the text view.
                    .padding(.bottom, 20)
                
                // Display a text view with instructions for the user.
                Text("Enter your email to search for your messages")
                    // Center the text in the label.
                    .multilineTextAlignment(.center)
                    // Customize the font
                    .font(.custom(Constants.defaultFont, size: Constants.mainScreenFontSize))
                
                // Display a TextField view for the user to enter their email.
                TextField("Email", text: $email)
                    //Give it focus when emailFocused is true
                    .focused($emailFocused)
                    // Use a rounded border style for the text field.
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    // Add some padding below the text field.
                    .padding(.bottom, 20)
                    // Set the keyboard type to .emailAddress so the user gets an email-optimized keyboard.
                    .keyboardType(.emailAddress)
                    // Disable automatic capitalization.
                    .autocapitalization(.none)
                    //Turn off autocorrect
                    .disableAutocorrection(true)
               
                
                
                // Display a Button view that the user can tap to search for messages.
                Button(action: { viewModel.fetchData(for: email) }) {
                    
                    Text("Search")
                        .font(.custom(Constants.defaultFont, size: Constants.mainScreenFontSize))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Constants.searchButtonColor)
                        .cornerRadius(40)
           
                }
                .disabled(!viewModel.isSearchButtonEnabled)
                // Create a navigation destination for the MessageCenterView.
                .navigationDestination(isPresented: $viewModel.navigateToMessageCenter) {
                    MessageCenterView(messages: viewModel.messages.sorted(by: { $0.date > $1.date }))
                }
                // Attach an alert to the button. The alert is shown when viewModel.showAlert is true.
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
                // Add some padding to the button.
                .padding(.horizontal, 20)
                
                
                // If viewModel.isLoading is true, show a progress view.
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 20)
                }
                
                // Use a Spacer view to push the above views towards the top of the screen.
                Spacer()
            }
            // Add some padding to the VStack.
            .padding()
            //When the screen appears, set the focus to the email textfield
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.emailFocused = true
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

