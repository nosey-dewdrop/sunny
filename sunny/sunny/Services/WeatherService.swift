import Foundation

class WeatherService {
    private let apiKey = Secrets.weatherAPIKey

    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(lat),\(lon)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
