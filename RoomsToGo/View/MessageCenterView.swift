//
//  MessageCenterView.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import SwiftUI

//Screen to show the user a list of messages for the provided email address.
struct MessageCenterView: View {
    // Message objects that will be displayed in the list.
    let messages: [Message]

    var body: some View {
        NavigationView {
            List {
                // section header that displays "Message Center" in bold
                Section(header:
                            Text("Message Center")
                            .font(.custom(Constants.messageCenterHeaderFont, size: Constants.messageCenterBoldFontSize))
                            .foregroundColor(Color.primary)
                            .padding(.top)
                            .padding(.bottom, 8)
                ) {
                    // Iterate over the messages array, displaying each message in a row.
                    ForEach(messages) { message in
                        HStack {
                            // text of the message
                            Text(message.message)
                                .font(.custom(Constants.defaultFont, size: Constants.messageCenterFontSize))
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            // date of the message
                            Text(message.date.customFormattedDate())
                                .font(.custom(Constants.defaultFont, size: Constants.messageCenterFontSize))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            // style for the list that removes the default styling.
            .listStyle(PlainListStyle())
        }
    }
}


struct MessageCenterView_Previews: PreviewProvider {
    static var previews: some View {
        
        // We use mock data here to enable a preview for this screen.
        let sampleMessages = [
            Message(name: "John Doe", date: Date(), message: "Your order has been shipped!"),
            Message(name: "Jane Doe", date: Date().addingTimeInterval(-360000), message: "There's a payment error"),
            Message(name: "Test User", date: Date().addingTimeInterval(-720000), message: "Order received")
        ]

        MessageCenterView(messages: sampleMessages)
    }
}


