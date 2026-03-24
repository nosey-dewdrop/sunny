import SwiftUI
import os

private let logger = Logger(subsystem: "com.damla.sunny", category: "HomeView")

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
    // error message shown to user
    @State private var errorMessage: String?

    // entrance animation states
    @State private var showCity = false
    @State private var showTemp = false
    @State private var showMessage = false

    // the service that calls weatherapi.com
    private let weatherService = WeatherService()

    var body: some View {
        ZStack {
            // background image - changes based on weather condition
            // crossfade between conditions + slow parallax drift
            Image(condition.assetName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.2), value: condition)

            // procreate frame animation overlay
            // add your frames as sun_anim_0, sun_anim_1, ... in Assets
            // and set the frameCount to match
            if condition == .sunny || condition == .kindaHot || condition == .reallyHot {
                FrameAnimationView(prefix: "sun_anim", frameCount: 6, fps: 0.12)
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }

            VStack(spacing: 32) {
                Spacer()
                Spacer()

                // city name from reverse geocoding — slides down + fades in
                Text(locationManager.cityName)
                    .font(.custom("PatrickHand-Regular", size: 26))
                    .tracking(2)
                    .foregroundStyle(.black)
                    .shadow(color: .white.opacity(0.5), radius: 3, y: 1)
                    .opacity(showCity ? 1 : 0)
                    .offset(y: showCity ? 0 : -20)

                // temperature or loading spinner — slides up + fades in
                if let weather = weather {
                    Text("\(Int(weather.current.tempC))°")
                        .font(.custom("PatrickHand-Regular", size: 96))
                        .tracking(4)
                        .foregroundStyle(.black)
                        .shadow(color: .white.opacity(0.4), radius: 6, y: 3)
                        .opacity(showTemp ? 1 : 0)
                        .offset(y: showTemp ? 0 : 30)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                } else if isLoading {
                    ProgressView()
                        .tint(.black)
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 12) {
                        Text(errorMessage)
                            .font(.custom("PatrickHand-Regular", size: 18))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Button("try again") {
                            self.errorMessage = nil
                            self.isLoading = true
                            fetchWeather()
                        }
                        .font(.custom("PatrickHand-Regular", size: 16))
                        .foregroundStyle(.black)
                    }
                }

                // cute message based on weather — fades in last
                Text(condition.message)
                    .font(.custom("PatrickHand-Regular", size: 18))
                    .tracking(1)
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .shadow(color: .white.opacity(0.4), radius: 3, y: 1)
                    .padding(.horizontal, 40)
                    .opacity(showMessage ? 1 : 0)
                    .offset(y: showMessage ? 0 : 15)

                Spacer()
            }
            .animation(.easeOut(duration: 0.6), value: showCity)
            .animation(.easeOut(duration: 0.6), value: showTemp)
            .animation(.easeOut(duration: 0.6), value: showMessage)
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

                // update ui on main thread with staggered entrance
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        condition = newCondition
                    }
                    weather = response
                    isLoading = false

                    // staggered entrance: city -> temp -> message
                    withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                        showCity = true
                    }
                    withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
                        showTemp = true
                    }
                    withAnimation(.easeOut(duration: 0.6).delay(0.8)) {
                        showMessage = true
                    }
                }

                // if notifications are on and it's hot enough, send reminder
                if settings.notificationsEnabled &&
                    response.current.tempC >= settings.temperatureThreshold {
                    NotificationManager.shared.sendSunscreenReminder(temp: response.current.tempC)
                }
            } catch {
                logger.error("Weather fetch failed: \(error.localizedDescription)")
                await MainActor.run {
                    errorMessage = "couldn't load weather. check your connection and try again."
                    isLoading = false
                }
            }
        }
    }
}
