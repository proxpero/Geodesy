#if os(OSX) || os(iOS)

    import CoreLocation

    extension Geohash {

        public static func encode(coordinate: CLLocationCoordinate2D, precision: Int = 8) -> String {
            return Region(latitude: coordinate.latitude, longitude: coordinate.longitude, precision: precision).hash
        }

        public static func encode(coordinate: CLLocationCoordinate2D, precision: Precision) -> String {
            return Region(latitude: coordinate.latitude, longitude: coordinate.longitude, precision: precision.rawValue).hash
        }

        public static func encode(location: CLLocation, precision: Int = 8) -> String {
            return Geohash.encode(coordinate: location.coordinate, precision: precision)
        }

        public static func encode(location: CLLocation, precision: Precision) -> String {
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

        public func geohash(precision: Int = 8) -> String {
            return Geohash.encode(coordinate: self, precision: precision)
        }

        public func geohash(precision: Geohash.Precision) -> String {
            return Geohash.encode(latitude: latitude, longitude: longitude, precision: precision)
        }

    }

    extension CLLocation {
        public convenience init?(geohash: String) {
            guard let region = Geohash.decode(geohash: geohash) else { return nil }
            self.init(latitude: region.center.latitude, longitude: region.center.longitude)
        }
    }

#endif
