import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

<<<<<<< HEAD
    GMSServices.provideAPIKey("GOOGLE_MAPS_API_KEY") // GOOGLE_MAPS_API_KEY
=======
    GMSServices.provideAPIKey("AIzaSyBtMsxojhdHqxIWPATrWE-EgqGt8UeQU7s")
>>>>>>> e76f51f4beb9c0f380ff8ff342ad91168551ceb6

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
