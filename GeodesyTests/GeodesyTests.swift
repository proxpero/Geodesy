import XCTest
import CoreLocation
@testable import Geodesy

class GeodesyTests: XCTestCase {

    func testEncodeDecode() {

        struct TestCase {
            let lat: Double
            let lng: Double
            let hash: String
            var precision: Int {
                return hash.count
            }
        }

        func runTestCase(_ testCase: TestCase) {
            let result = Region(latitude: testCase.lat, longitude: testCase.lng, precision: testCase.precision).hash
            let reverse = Region(hash: result)
            XCTAssertEqual(testCase.hash, result)
            XCTAssertNotNil(reverse)
            XCTAssertEqual(reverse!.center.latitude, testCase.lat, accuracy: 0.00005)
            XCTAssertEqual(reverse!.center.longitude, testCase.lng, accuracy: 0.00005)
        }

        [                                                                                     // these values come from http://geohash.com
            TestCase(lat:  40.77955232064873,  lng: -73.9636630564928,   hash: "dr5ruztq1"),  // Metropolitan Museum of Art, New York
            TestCase(lat:  37.9715286848901,   lng:  23.726720362901688, hash: "swbb5bt20"),  // Acropolis of Athens
            TestCase(lat: -77.84210082417549,  lng: 166.68628692626953,  hash: "pdnt1j32b"),  // McMurdo Station, Antarctica
            TestCase(lat: -20.395640574216085, lng:  57.4394416809082,   hash: "mk2ggp44u")   // Black River Gorges National Park
        ].forEach(runTestCase)
    }

    func testCLCoordinates() {

        let precision: Precision = .twoHundredFortyCentimeters

        func runTestCase(coord: CLLocationCoordinate2D, hash: String) {
            let region = Region(coordinate: coord, precision: precision.rawValue).hash
            XCTAssertEqual(region, hash)
        }

        [
            (CLLocationCoordinate2D(latitude:  40.77955232064873,  longitude: -73.9636630564928),   "dr5ruztq1"),
            (CLLocationCoordinate2D(latitude:  37.9715286848901,   longitude:  23.726720362901688), "swbb5bt20"),
            (CLLocationCoordinate2D(latitude: -77.84210082417549,  longitude: 166.68628692626953),  "pdnt1j32b"),
            (CLLocationCoordinate2D(latitude: -20.395640574216085, longitude:  57.4394416809082),   "mk2ggp44u")
        ].forEach(runTestCase)
    }

    func testNeighbors() {

        struct TestCase {
            let center: String
            let neighbors: [String]
        }

        func runTestCase(testCase: TestCase) {
            let region = Region(hash: testCase.center)!
            XCTAssertEqual(region.neighbors().map { $0.hash }, testCase.neighbors)
        }

        [
            TestCase(center: "ezs42", neighbors: ["ezs48", "ezs49", "ezs43", "ezs41", "ezs40", "ezefp", "ezefr", "ezefx"]),
            TestCase(center: "u000", neighbors: ["u001", "u003", "u002", "spbr", "spbp", "ezzz", "gbpb", "gbpc"]),
            TestCase(center: "0", neighbors: ["2", "3", "1", "j", "h", "5", "p", "r"]),
            TestCase(center: "1", neighbors: ["3", "6", "4", "n", "j", "h", "0", "2"]),
            TestCase(center: "2", neighbors: ["8", "9", "3", "1", "0", "p", "r", "x"]),
            TestCase(center: "3", neighbors: ["9", "d", "6", "4", "1", "0", "2", "8"]),
            TestCase(center: "4", neighbors: ["6", "7", "5", "p", "n", "j", "1", "3"]),
            TestCase(center: "5", neighbors: ["7", "k", "h", "0", "p", "n", "4", "6"]),
            TestCase(center: "6", neighbors: ["d", "e", "7", "5", "4", "1", "3", "9"]),
            TestCase(center: "7", neighbors: ["e", "s", "k", "h", "5", "4", "6", "d"]),
            TestCase(center: "8", neighbors: ["b", "c", "9", "3", "2", "r", "x", "z"]),
            TestCase(center: "9", neighbors: ["c", "f", "d", "6", "3", "2", "8", "b"]),
            TestCase(center: "b", neighbors: ["u", "v", "c", "9", "8", "x", "z", "g"]),
            TestCase(center: "c", neighbors: ["v", "y", "f", "d", "9", "8", "b", "u"]),
            TestCase(center: "d", neighbors: ["f", "g", "e", "7", "6", "3", "9", "c"]),
            TestCase(center: "e", neighbors: ["g", "u", "s", "k", "7", "6", "d", "f"]),
            TestCase(center: "f", neighbors: ["y", "z", "g", "e", "d", "9", "c", "v"]),
            TestCase(center: "g", neighbors: ["z", "z", "u", "s", "e", "d", "f", "y"]),
            TestCase(center: "h", neighbors: ["k", "m", "j", "1", "0", "p", "5", "7"]),
            TestCase(center: "j", neighbors: ["m", "q", "n", "4", "1", "0", "h", "k"]),
            TestCase(center: "k", neighbors: ["s", "t", "m", "j", "h", "5", "7", "e"]),
            TestCase(center: "m", neighbors: ["t", "w", "q", "n", "j", "h", "k", "s"]),
            TestCase(center: "n", neighbors: ["q", "r", "p", "5", "4", "1", "j", "m"]),
            TestCase(center: "p", neighbors: ["r", "2", "0", "h", "5", "4", "n", "q"]),
            TestCase(center: "q", neighbors: ["w", "x", "r", "p", "n", "j", "m", "t"]),
            TestCase(center: "r", neighbors: ["x", "8", "2", "0", "p", "n", "q", "w"]),
            TestCase(center: "s", neighbors: ["u", "v", "t", "m", "k", "7", "e", "g"]),
            TestCase(center: "t", neighbors: ["v", "y", "w", "q", "m", "k", "s", "u"]),
            TestCase(center: "u", neighbors: ["b", "c", "v", "t", "s", "e", "g", "z"]),
            TestCase(center: "v", neighbors: ["c", "f", "y", "w", "t", "s", "u", "z"]),
            TestCase(center: "w", neighbors: ["y", "z", "x", "r", "q", "m", "t", "v"]),
            TestCase(center: "x", neighbors: ["z", "b", "8", "2", "r", "q", "w", "y"]),
            TestCase(center: "y", neighbors: ["f", "g", "z", "x", "w", "t", "v", "c"]),
            TestCase(center: "z", neighbors: ["g", "u", "b", "8", "x", "w", "y", "f"])
        ].forEach(runTestCase)
    }

    func testNorth() {
        
        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let north = region.north(region, precision)
            let hash = north.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("b", "u"),
            ("c", "v"),
            ("f", "y"),
            ("g", "z"),
            ("u", "b"),
            ("v", "c"),
            ("y", "f"),
            ("z", "g"),
            ("r", "x"),
            ("2", "8"),
            ("3", "9"),
            ("6", "d"),
            ("7", "e"),
            ("k", "s"),
            ("m", "t"),
            ("q", "w"),
            ("r", "x")
        ].forEach(runTest)
    }

    func testSouth() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let south = region.south(region, precision)
            let hash = south.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("p", "5"),
            ("0", "h"),
            ("1", "j"),
            ("4", "n"),
            ("5", "p"),
            ("h", "0"),
            ("j", "1"),
            ("n", "4"),
            ("8", "2"),
            ("9", "3"),
            ("d", "6"),
            ("e", "7"),
            ("s", "k"),
            ("t", "m"),
            ("w", "q"),
            ("x", "r")
        ].forEach(runTest)
    }

    func testEast() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let east = region.east(region, precision)
            let hash = east.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("r", "2"),
            ("2", "3"),
            ("3", "6"),
            ("6", "7"),
            ("7", "k"),
            ("k", "m"),
            ("m", "q"),
            ("q", "r"),
            ("p", "0"),
            ("0", "1"),
            ("1", "4"),
            ("4", "5"),
            ("5", "h"),
            ("h", "j"),
            ("j", "n"),
            ("n", "p")
        ].forEach(runTest)
    }

    func testWest() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let west = region.west(region, precision)
            let hash = west.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("r", "q"),
            ("2", "r"),
            ("3", "2"),
            ("6", "3"),
            ("7", "6"),
            ("k", "7"),
            ("m", "k"),
            ("q", "m"),
            ("p", "n"),
            ("0", "p"),
            ("1", "0"),
            ("4", "1"),
            ("5", "4"),
            ("h", "5"),
            ("j", "h"),
            ("n", "j")
        ].forEach(runTest)
    }

    func testNortheast() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let northeast = region.northeast(region, precision)
            let hash = northeast.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("f", "z"),
            ("c", "y"),
            ("b", "v"),
            ("z", "u"),
            ("y", "g"),
            ("v", "f"),
            ("u", "c"),
//            ("g", "b"), // g nw -> z,
            ("r", "8"),
            ("2", "9"),
            ("3", "d"),
            ("6", "e"),
            ("7", "s"),
            ("k", "t"),
            ("m", "w"),
            ("q", "x")
        ].forEach(runTest)
    }

    func testSoutheast() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let southeast = region.southeast(region, precision)
            let hash = southeast.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("p", "h"),
            ("0", "j"),
            ("1", "n"),
            ("4", "p"),
            ("5", "0"),
            ("h", "1"),
            ("j", "4"),
            ("n", "5"),
            ("s", "m"),
            ("t", "q"),
            ("w", "r"),
            ("x", "2"),
            ("8", "3"),
            ("9", "6"),
            ("d", "7"),
            ("e", "k")
        ].forEach(runTest)
    }

    func testSouthwest() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let southwest = region.southwest(region, precision)
            let hash = southwest.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("0", "5"),
            ("1", "h"),
            ("4", "j"),
            ("5", "n"),
            ("h", "p"),
            ("j", "0"),
            ("n", "1"),
            ("p", "4"),
            ("8", "r"),
            ("9", "2"),
            ("d", "3"),
            ("e", "6"),
            ("s", "7"),
            ("t", "k"),
            ("w", "m"),
            ("x", "q")
        ].forEach(runTest)
    }

    func testNorthwest() {

        func runTest(center: String, neighbor: String) {
            let precision = center.count
            let region = Region(hash: center)!
            let northwest = region.northwest(region, precision)
            let hash = northwest.hash
            XCTAssertEqual(hash, neighbor)
        }

        [
            ("u", "z"),
//            ("v", "b"), // g nw b -> z
            ("y", "c"),
            ("z", "f"),
            ("b", "g"),
            ("c", "u"),
            ("f", "v"),
            ("g", "y"),
            ("2", "x"),
            ("3", "8"),
            ("6", "9"),
            ("7", "d"),
            ("k", "e"),
            ("m", "s"),
            ("q", "t"),
            ("r", "w")
        ].forEach(runTest)
    }
    
}
