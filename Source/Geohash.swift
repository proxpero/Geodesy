public enum Geohash {

    public static func encode(latitude: Double, longitude: Double, precision: Int = 8) -> String {
        return Region(latitude: latitude, longitude: longitude, precision: precision).hash
    }

    public static func encode(latitude: Double, longitude: Double, precision: Precision) -> String {
        return Geohash.encode(latitude: latitude, longitude: longitude, precision: precision.rawValue)
    }

    public static func decode(geohash: String) -> Region? {
        guard let region = Region(hash: geohash) else { return nil }
        return region
    }
}

extension Geohash {


    public enum Precision: Int {

        /// ±2500 km
        case twentyFiveHundredKilometers = 1

        /// ±630 km
        case sixHundredThirtyKilometers

        /// ±78 km
        case seventyEightKilometers

        /// ±20 km
        case twentyKilometers

        /// ±2.4 km, ±2400 m
        case twentyFourHundredMeters

        /// ±0.61 km, ±610 m
        case sixHundredTenMeters

        /// ±0.076 km, ±76 m
        case seventySixMeters

        /// ±0.019 km, ±19 m
        case nineteenMeters

        /// ±0.0024 km, ±2.4 m, ±240 cm
        case twoHundredFortyCentimeters

        /// ±0.00060 km, ±0.6 m, ±60 cm
        case sixtyCentimeters

        /// ±0.000074 km, ±0.07 m, ±7.4 cm, ±74 mm
        case seventyFourMillimeters

        var margin: Double {
            switch self {
            case .twentyFiveHundredKilometers: return 2_500_000.0
            case .sixHundredThirtyKilometers: return 610_000.0
            case .seventyEightKilometers: return 78_000.0
            case .twentyKilometers: return 20_000.0
            case .twentyFourHundredMeters: return 2_400.0
            case .sixHundredTenMeters: return 610.0
            case .seventySixMeters: return 76.0
            case .nineteenMeters: return 19.0
            case .twoHundredFortyCentimeters: return 2.4
            case .sixtyCentimeters: return 0.6
            case .seventyFourMillimeters: return 0.07
            }
        }
    }
}
