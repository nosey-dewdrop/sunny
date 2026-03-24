import Foundation
import os

private let logger = Logger(subsystem: "com.damla.sunny", category: "WeatherService")

enum WeatherServiceError: LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not build weather request URL."
        case .serverError(let code):
            return "Weather server returned status \(code)."
        case .noData:
            return "No weather data received."
        }
    }
}

class WeatherService {
    private let apiKey = Secrets.weatherAPIKey

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        // safe URL construction with URLComponents
        var components = URLComponents(string: "https://api.weatherapi.com/v1/current.json")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(lat),\(lon)")
        ]

        guard let url = components?.url else {
            logger.error("Failed to construct weather URL for lat=\(lat), lon=\(lon)")
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // validate HTTP status code
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Response is not HTTP")
            throw WeatherServiceError.noData
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            logger.error("Weather API returned status \(httpResponse.statusCode)")
            throw WeatherServiceError.serverError(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
