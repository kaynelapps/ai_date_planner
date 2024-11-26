import UIKit
import Flutter
import Firebase
import FirebaseAppCheck
import Photos
import CoreLocation
import GoogleMobileAds
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: NSObject, FlutterAppDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Move Firebase configuration to the top
        FirebaseApp.configure()
        
        // Configure AppCheck after Firebase
        if FirebaseApp.app() != nil {
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        }
        
        // Initialize other services
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GeneratedPluginRegistrant.register(withRegistry: self)
        
        // Setup location and permissions
        setupLocationManager()
        requestPhotoLibraryAccess()
        requestTrackingAuthorization()
        
        return true
    }
    
    private func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func requestPhotoLibraryAccess() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                self?.handlePhotoAuthStatus(status == .authorized || status == .limited)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                self?.handlePhotoAuthStatus(status == .authorized)
            }
        }
    }
    
    private func handlePhotoAuthStatus(_ granted: Bool) {
        DispatchQueue.main.async {
            UserDefaults.standard.set(granted, forKey: "PhotoPermissionGranted")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let isAuthorized = (status == .authorizedAlways || status == .authorizedWhenInUse)
        UserDefaults.standard.set(isAuthorized, forKey: "LocationPermissionGranted")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "LastLatitude")
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "LastLongitude")
    }
}
