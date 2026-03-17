import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let country: String
}

struct CurrentWeather: Codable {
    let tempC: Double
    let condition: WeatherConditionInfo

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
    }
}

struct WeatherConditionInfo: Codable {
    let text: String
    let code: Int
}
