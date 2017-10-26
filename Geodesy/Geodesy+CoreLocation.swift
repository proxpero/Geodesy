#if os(OSX) || os(iOS)

    import CoreLocation

    extension CLLocationCoordinate2D {
        init(geohash: String) {
            guard let region = Geohash.decode(geohash: geohash) else {
                self = kCLLocationCoordinate2DInvalid
                return
            }
            let (lat, lng) = region.center
            self = CLLocationCoordinate2DMake(lat, lng)
        }

        func geohash(precision: Int = 8) -> String {
            return Geohash.encode(latitude: latitude, longitude: longitude, precision: precision)
        }

        func geohash(precision: Geohash.Precision) -> String {
            return Geohash.encode(latitude: latitude, longitude: longitude, precision: precision)
        }

    }

    extension CLLocation {
        convenience init?(geohash: String) {
            guard let region = Geohash.decode(geohash: geohash) else { return nil }
            self.init(latitude: region.center.latitude, longitude: region.center.longitude)
        }
    }

#endif
