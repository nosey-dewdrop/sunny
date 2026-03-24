import Foundation

enum WeatherCondition: String, CaseIterable {
    case sunny
    case blueSky
    case kindaHot
    case reallyHot
    case cloudy
    case sunnyCloudy
    case sunnyCloudyRainy
    case raining

    var assetName: String {
        switch self {
        case .sunny: return "sunny"
        case .blueSky: return "blue_sky"
        case .kindaHot: return "kinda_hot"
        case .reallyHot: return "really_hot"
        case .cloudy: return "cloud"
        case .sunnyCloudy: return "sunny_cloudy"
        case .sunnyCloudyRainy: return "sunny_cloudy_rainy"
        case .raining: return "raining"
        }
    }

    var message: String {
        switch self {
        case .sunny:
            return "what a beautiful day! don't forget spf! 🌞"
        case .blueSky:
            return "blue blue sky! 💙"
        case .kindaHot:
            return "a little hot! don't forget spf! 🧴"
        case .reallyHot:
            return "really HOT!! SPF is a must! 🔥"
        case .cloudy:
            return "cloudy but don't skip sunscreen, UV rays sneak through ☁️"
        case .sunnyCloudy:
            return "peekaboo sun today, keep your sunscreen close 🌤"
        case .sunnyCloudyRainy:
            return "mixed weather, grab both umbrella and sunscreen 🌦"
        case .raining:
            return "rainy day, sunscreen can take a break 🌧"
        }
    }

    static func from(code: Int, tempC: Double) -> WeatherCondition {
        if tempC >= 40 { return .reallyHot }
        if tempC >= 30 { return .kindaHot }

        switch code {
        case 1000:
            return .sunny
        case 1003:
            return .sunnyCloudy
        case 1006, 1009:
            return .cloudy
        case 1030, 1063, 1150, 1153, 1168, 1171:
            return .sunnyCloudyRainy
        case 1180, 1183, 1186, 1189, 1192, 1195,
             1198, 1201, 1240, 1243, 1246:
            return .raining
        default:
            return .blueSky
        }
    }
}
