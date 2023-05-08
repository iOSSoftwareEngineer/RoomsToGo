//
//  MessageCenter.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import Foundation

import SwiftUI

struct MessageCenter: View {
    let messages: [Message]

    var body: some View {
        NavigationView {
            List {
                Section(header:
                            Text("Message Center")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.black)
                            .padding(.top)
                            .padding(.bottom, 8)
                ) {
                    ForEach(messages) { message in
                        HStack {
                            Text(message.message)
                                .font(.custom("Poppins-Regular", size: 14))
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text(customFormattedDate(from: message.date))
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }

    private func customFormattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yyyy"
        return formatter.string(from: date)
    }
}




