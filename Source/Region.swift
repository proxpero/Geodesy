private let charmap = Array("0123456789bcdefghjkmnpqrstuvwxyz")

public struct Region {
    public let horizontal: Span
    public let vertical: Span
    public let hash: String
}

extension Region {

    public var center: (latitude: Double, longitude: Double) {
        return (vertical.mean, horizontal.mean)
    }

    public var size: (vertical: Double, horizontal: Double) {
        return (vertical.distance, horizontal.distance)
    }

    public init(latitude: Double, longitude: Double, precision: Int) {

        var lat = Span.latitude
        var lng = Span.longitude

        var hash: Array<Character> = []

        var parity = Parity.lng
        var char = 0
        var count = 0

        func inc() {
            let mask = 0b10000 >> count
            char |= mask
        }

        func compare(span: Span, source: Double) -> Span {
            let mean = span.mean
            let isLow = source < mean
            let (min, max) = isLow ? (span.min, mean) : (mean, span.max)
            if !isLow { inc() }
            return Span(min: min, max: max)
        }

        repeat {
            switch parity {
            case .lng: lng = compare(span: lng, source: longitude)
            case .lat: lat = compare(span: lat, source: latitude)
            }
            parity.flip()
            count += 1
            if count == 5 {
                hash.append(charmap[char])
                count = 0
                char = 0
            }

        } while hash.count < precision

        let vert = Span(min: lat.min, max: lat.max)
        let hor = Span(min: lng.min, max: lng.min)

        self = Region(horizontal: hor, vertical: vert, hash: String(hash))

    }

    public init?(hash: String) {

        var lat = Span.latitude
        var lng = Span.longitude

        var parity = Parity.lng

        for char in hash {
            guard let bitmap = charmap.firstIndex(of: char) else { return nil }
            var mask = 0b10000

            func compare(span: Span) -> Span {
                let mean = span.mean
                let isLow = bitmap & mask == 0
                let (min, max) = isLow ? (span.min, mean) : (mean, span.max)
                return Span(min: min, max: max)
            }

            while mask != 0 {
                switch parity {
                case .lng: lng = compare(span: lng)
                case .lat: lat = compare(span: lat)
                }
                parity.flip()
                mask >>= 1
            }
        }
        self = Region(horizontal: lng, vertical: lat, hash: hash)
    }

    func north(_ region: Region, _ precision: Int) -> Region {
        let lat = region.center.latitude
        let lng = region.center.longitude
        let v = region.vertical.distance
        let n = lat + v
        if n > 90.0 {
            var k = lng + 180.0
            if k > 180.0 { k -= 360.0 }
            return Region(latitude: lat, longitude: k, precision: precision)
        }
        return Region(latitude: n, longitude: lng, precision: precision)
    }

    func east(_ region: Region, _ precision: Int) -> Region {
        let lat = region.center.latitude
        let lng = region.center.longitude
        let h = region.horizontal.distance
        var n = lng + h
        if n > 180.0 { n -= 360.0 }
        return Region(latitude: lat, longitude: n, precision: precision)
    }

    func south(_ region: Region, _ precision: Int) -> Region {
        let lat = region.center.latitude
        let lng = region.center.longitude
        let v = region.vertical.distance
        let n = lat - v
        if n < -90.0 {
            var k = lng - 180
            if k < -180.0 { k += 360.0 }
            return Region(latitude: lat, longitude: k, precision: precision)
        }
        return Region(latitude: n, longitude: lng, precision: precision)
    }

    func west(_ region: Region, _ precision: Int) -> Region {
        let lat = region.center.latitude
        let lng = region.center.longitude
        let h = region.horizontal.distance
        var n = lng - h
        if n < -180.0 { n += 360.0 }
        return Region(latitude: lat, longitude: n, precision: precision)
    }

    func northeast(_ region: Region, _ precision: Int) -> Region {
        return north(east(region, precision), precision)
    }

    func southeast(_ region: Region, _ precision: Int) -> Region {
        return south(east(self, precision), precision)
    }

    func southwest(_ region: Region, _ precision: Int) -> Region {
        return south(west(self, precision), precision)
    }

    func northwest(_ region: Region, _ precision: Int) -> Region {
        return north(west(self, precision), precision)
    }

    public func neighbors() -> [Region] {
        let precision = hash.count
        return [
            north(self, precision),
            northeast(self, precision),
            east(self, precision),
            southeast(self, precision),
            south(self, precision),
            southwest(self, precision),
            west(self, precision),
            northwest(self, precision)
        ]
    }

    private enum Parity {
        case lng
        case lat
        mutating func flip() {
            switch self {
            case .lng: self = .lat
            case .lat: self = .lng
            }
        }
    }

}
