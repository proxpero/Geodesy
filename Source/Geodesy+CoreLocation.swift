#if os(OSX) || os(iOS)

    import CoreLocation

    extension Region {

        init(coordinate: CLLocationCoordinate2D, precision: Int = defaultPrecision) {
            self = Region(latitude: coordinate.latitude, longitude: coordinate.longitude, precision: precision)
        }

        init(location: CLLocation, precision: Int = defaultPrecision) {
            self = Region(coordinate: location.coordinate, precision: precision)
        }

    }

    extension CLLocationCoordinate2D {

        public init(geohash: String) {
            guard let region = Region(hash: geohash) else {
                self = kCLLocationCoordinate2DInvalid
                return
            }
            let (lat, lng) = region.center
            self = CLLocationCoordinate2DMake(lat, lng)
        }

        public func geohash(precision: Int = defaultPrecision) -> String {
            return Region(coordinate: self, precision: precision).hash
        }

        public func geohash(precision: Precision) -> String {
            return Region(coordinate: self, precision: precision.rawValue).hash
        }

    }

    extension CLLocation {

        public convenience init?(geohash: String) {
            guard let region = Region.init(hash: geohash) else { return nil }
            self.init(latitude: region.center.latitude, longitude: region.center.longitude)
        }

        public func geohash(precision: Int = defaultPrecision) -> String {
            return Region(coordinate: self.coordinate, precision: precision).hash
        }

        public func geohash(precision: Precision) -> String {
            return geohash(precision: precision.rawValue)
        }

        /// Geohash neighbors
        public func neighbors(precision: Int = defaultPrecision) -> [String] {
            return Region.init(location: self, precision: precision).neighbors().map { $0.hash }
        }

        public func neighbors(precision: Precision) -> [String] {
            return neighbors(precision: precision.rawValue)
        }

    }

#endif
