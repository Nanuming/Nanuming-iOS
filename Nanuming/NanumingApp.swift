//
//  NanumingApp.swift
//  Nanuming
//
//  Created by 가은 on 1/24/24.
//

import SwiftUI
import GoogleMaps
import GoogleSignIn

let googleMapApiKey = Bundle.main.infoDictionary?["GOOGLE_MAP_API_KEY"] ?? "No google map api key"

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey(googleMapApiKey as! String)
        
        return true
    }
}


@main
struct NanumingApp: App {
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
