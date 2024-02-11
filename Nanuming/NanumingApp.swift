//
//  NanumingApp.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI
import GoogleMaps
import GoogleSignIn

@main
struct NanumingApp: App {
    
    init() {
        let googleMapApiKey = Bundle.main.infoDictionary?["GOOGLE_MAP_API_KEY"] as? String ?? "No google map api key"
        GMSServices.provideAPIKey(googleMapApiKey)
    }
    
    var body: some Scene {
        WindowGroup {
            EntryView(userData: UserData(email: "", IDToken: "", picture: nil))
                .onOpenURL { url in
                          GIDSignIn.sharedInstance.handle(url)
                        }
                .onAppear {
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                    }
                }
        }
    }

}
