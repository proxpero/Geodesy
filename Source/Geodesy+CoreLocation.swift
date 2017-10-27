#if os(OSX) || os(iOS)

    import CoreLocation

    extension Geohash {

        public static func region(for coordinate: CLLocationCoordinate2D, precision: Int = defaultPrecision) -> Region {
            return Region(latitude: coordinate.latitude, longitude: coordinate.longitude, precision: precision)
        }

        public static func region(for coordinate: CLLocationCoordinate2D, precision: Precision = Precision(rawValue: defaultPrecision)!) -> Region {
            return Region(latitude: coordinate.latitude, longitude: coordinate.longitude, precision: precision.rawValue)
        }

        public static func region(for location: CLLocation, precision: Int = defaultPrecision) -> Region {
            return region(for: location.coordinate, precision: precision)
        }

        public static func region(for location: CLLocation, precision: Precision = Precision(rawValue: defaultPrecision)!) -> Region {
            return region(for: location.coordinate, precision: precision.rawValue)
        }

        public static func encode(coordinate: CLLocationCoordinate2D, precision: Int = defaultPrecision) -> String {
            return region(for: coordinate, precision: precision).hash
        }

        public static func encode(coordinate: CLLocationCoordinate2D, precision: Precision = Precision(rawValue: defaultPrecision)!) -> String {
            return region(for: coordinate, precision: precision.rawValue).hash
        }

        public static func encode(location: CLLocation, precision: Int = defaultPrecision) -> String {
            return Geohash.encode(coordinate: location.coordinate, precision: precision)
        }

        public static func encode(location: CLLocation, precision: Precision = Precision(rawValue: defaultPrecision)!) -> String {
            return Geohash.encode(coordinate: location.coordinate, precision: precision.rawValue)
        }

    }

    extension CLLocationCoordinate2D {

        public init(geohash: String) {
            guard let region = Geohash.decode(geohash: geohash) else {
                self = kCLLocationCoordinate2DInvalid
                return
            }
            let (lat, lng) = region.center
            self = CLLocationCoordinate2DMake(lat, lng)
        }

        public func geohash(precision: Int = defaultPrecision) -> String {
            return Geohash.encode(coordinate: self, precision: precision)
        }

        public func geohash(precision: Geohash.Precision = Geohash.Precision(rawValue: defaultPrecision)!) -> String {
            return Geohash.encode(latitude: latitude, longitude: longitude, precision: precision)
        }

    }

    extension CLLocation {

        public convenience init?(geohash: String) {
            guard let region = Geohash.decode(geohash: geohash) else { return nil }
            self.init(latitude: region.center.latitude, longitude: region.center.longitude)
        }

        public func geohash(precision: Int = defaultPrecision) -> String {
            return Geohash.encode(location: self, precision: precision)
        }

        public func geohash(precision: Geohash.Precision = Geohash.Precision(rawValue: defaultPrecision)!) -> String {
            return geohash(precision: precision.rawValue)
        }

        /// Geohash neighbors
        public func neighbors(precision: Int = defaultPrecision) -> [String] {
            return Geohash.region(for: self, precision: precision).neighbors().map { $0.hash }
        }

        public func neighbors(precision: Geohash.Precision = Geohash.Precision(rawValue: defaultPrecision)!) -> [String] {
            return neighbors(precision: precision.rawValue)
        }

    }

#endif
