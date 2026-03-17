# sunny

A weather app for iOS that shows current conditions with illustrated backgrounds and reminds you to wear sunscreen on hot days.

## Features

- Real-time weather based on your location using WeatherAPI
- Hand-drawn style background illustrations that change with the weather (sunny, cloudy, rainy, hot, etc.)
- Sunscreen reminder notifications when temperature exceeds your threshold
- Adjustable temperature threshold via settings
- Reverse geocoding to display your city name
- 8 unique weather conditions with custom artwork and messages

## Screenshots

<!-- Add screenshots here -->

## Setup

1. Clone the repo
2. Get a free API key from [weatherapi.com](https://www.weatherapi.com)
3. Create `sunny/Config/Secrets.swift` with:
   ```swift
   enum Secrets {
       static let weatherAPIKey = "YOUR_API_KEY"
   }
   ```
4. Open `sunny.xcodeproj` in Xcode and run

> `Secrets.swift` is gitignored — never commit your API key.

## Tech Stack

- SwiftUI
- CoreLocation
- UserNotifications
- WeatherAPI (current weather endpoint)

## License

MIT
