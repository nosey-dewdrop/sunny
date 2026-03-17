import SwiftUI

struct HomeView: View {
    
    // gets user's location (lat, lon, city name)
    @StateObject private var locationManager = LocationManager()
    // shared settings (temp threshold, notifications on/off)
    @ObservedObject var settings: UserSettings

    // api response stored here
    @State private var weather: WeatherResponse?
    // current weather condition — decides background image + message
    @State private var condition: WeatherCondition = .blueSky
    // shows spinner while waiting for api
    @State private var isLoading = true

    // the service that calls weatherapi.com
    private let weatherService = WeatherService()

    var body: some View {
        ZStack {
            // background image - changes based on weather condition
            Image(condition.assetName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // city name from reverse geocoding
                Text(locationManager.cityName)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)

                // temperature or loading spinner
                if let weather = weather {
                    Text("\(Int(weather.current.tempC))°")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundStyle(.white)
                } else if isLoading {
                    ProgressView()
                        .tint(.white)
                }

                // cute message based on weather
                Text(condition.message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)

                Spacer()
                Spacer()
            }
        }
        // when location updates, fetch weather
        .onChange(of: locationManager.latitude) {
            fetchWeather()
        }
        // ask for location when screen appears
        .onAppear {
            locationManager.requestLocation()
        }
    }

    // calls the weather api and updates the ui
    private func fetchWeather() {
        guard let lat = locationManager.latitude,
              let lon = locationManager.longitude else { return }

        Task {
            do {
                // call api with coordinates
                let response = try await weatherService.fetchWeather(lat: lat, lon: lon)
                // figure out which condition matches (sunny, raining, etc)
                let newCondition = WeatherCondition.from(
                    code: response.current.condition.code,
                    tempC: response.current.tempC
                )

                // update ui on main thread
                await MainActor.run {
                    weather = response
                    condition = newCondition
                    isLoading = false
                }

                // if notifications are on and it's hot enough, send reminder
                if settings.notificationsEnabled &&
                    response.current.tempC >= settings.temperatureThreshold {
                    NotificationManager.shared.sendSunscreenReminder(temp: response.current.tempC)
                }
            } catch {
                print("weather fetch error: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }
}
