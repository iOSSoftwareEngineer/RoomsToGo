//
//  MessageCenter.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import SwiftUI

struct MessageCenter: View {
    // array of Message objects that will be displayed in the list.
    let messages: [Message]

    var body: some View {
        NavigationView {
            List {
                // section header that displays "Message Center" in bold
                Section(header:
                            Text("Message Center")
                            .font(.custom(Constants.messageCenterHeaderFont, size: Constants.messageCenterBoldFontSize))
                            .foregroundColor(.black)
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
                            
                            // date of the message, formatted as a string using the customFormattedDate method
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
