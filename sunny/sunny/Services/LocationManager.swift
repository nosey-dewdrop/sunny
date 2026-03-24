import CoreLocation
import os

private let logger = Logger(subsystem: "com.damla.sunny", category: "LocationManager")

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var cityName: String = ""
    @Published var denied = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                logger.error("Reverse geocoding failed: \(error.localizedDescription)")
            }
            if let city = placemarks?.first?.locality {
                DispatchQueue.main.async {
                    self?.cityName = city
                }
            } else if error != nil {
                // fallback to coordinates if geocoding fails
                DispatchQueue.main.async {
                    self?.cityName = String(format: "%.1f, %.1f", location.coordinate.latitude, location.coordinate.longitude)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Location error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            denied = false
        case .denied, .restricted:
            denied = true
        default:
            break
        }
    }
}
