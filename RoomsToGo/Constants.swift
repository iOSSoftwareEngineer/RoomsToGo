//
//  Constants.swift
//  RoomsToGo
//
//  Created by Richard B. Rubin on 5/8/23.
//

import SwiftUI

struct Constants {

    //Message Service
    static let baseURL = "https://vcp79yttk9.execute-api.us-east-1.amazonaws.com/messages/users/"

    //Fonts
    static let defaultFont = "Poppins-Regular"
    static let messageCenterHeaderFont = "Poppins-Bold"
    
    //Main screen (search)
    static let mainScreenFontSize = 16.0
    static let mainScreenHeaderFontSize = 24.0
    static let searchButtonColor = Color(red: 0, green: 79/255, blue: 181/255)  //#004FB5
    
    //Message Center (output)
    static let messageCenterFontSize = 14.0
    static let messageCenterBoldFontSize = 16.0
}
