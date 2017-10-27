public struct Span {
    public let min: Double
    public let max: Double
}

extension Span {

    public var mean: Double { return (min + max) / 2 }
    public var distance: Double { return max - min }

    static let latitude = Span(min: -90.0, max: 90.0)
    static let longitude = Span(min: -180, max: 180)

}
