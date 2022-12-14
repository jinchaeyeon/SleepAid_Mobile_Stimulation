import UIKit
import Flutter
import NaverThirdPartyLogin
 import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // base flutter application
      override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }

//    // code for naver login 1.2.4
//     override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//         return NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
//     }

//     //   // code for naver login 1.6.0
//     override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//         var applicationResult = false
//         if (!applicationResult) {
//            applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
//         }
//         // if you use other application url process, please add code here.
//
//         if (!applicationResult) {
//            applicationResult = super.application(app, open: url, options: options)
//         }
//         return applicationResult
//     }

//   // code for naver login 1.4.0
//   override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//       return NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
//   }

  // base flutter application
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
}
