# Geodesy
![](https://travis-ci.org/proxpero/Geodesy.svg?branch=master)
<a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-red.svg" alt="MIT">
</a>
<a href="https://cocoapods.org/">
    <img src="https://cocoapod-badges.herokuapp.com/v/Geodesy/badge.png" alt="CocoaPods">
</a>
<a href="https://swift.org">
    <img src="https://img.shields.io/badge/Swift-5-green.svg" alt="Swift" />
</a>

### A Swift implementation of the [geohash][1] algorithm.

Geodesy comes from the ancient Greek word [γεωδαισία][2] which means *dividing the earth*. This is basically what the geohash algorithm does. The hash is just a string of characters, the first divides the earth into 32 separate regions, measured precisely along lines of latitude and longitude. Then next character subdivides a region further into 32 subsections. On and on it goes, each added character more precisely specifying a location on the globe. Nice!

The beauty of the algorithm really shines when you want to filter a list of locations by proximity to a given location. Instead of running some complicated trigonometry on all the points, you can simply compare geohashes. The nearest points will be the ones who share the longest prefix with the given point's geohash.

    let currentGeohash = user.location.geohash()
    let nearby = db.hotspots.where("geohash", beginsWith: currentGeohash.prefix(8))

Violá. A hash length 8 characters long defines a square roughly 38 meters per side.

### Usage

Geodesy is designed to be convenient to use with `CoreLocation`. There are a number of useful properties added in extensions on `CLLocation` and `CLLocationCoordinate2D`.
```
let location: CLLocation = manager.currentLocation
let geohash = location.geohash(precision: 8) // An eight-character geohash of type String
let neighbors = location.neighbors(precision: 8) // An array of nine eight-character strings representing the eight regions surrounding the original region.

```

### Neighbors?

To handle cases where a location sits near the border of its enclosing region, so that nearby locations potentially are just in the next region over, it is easy to include the eight neighboring regions in addition to actual one.


[1]:[https://en.m.wikipedia.org/wiki/Geohash]
[2]:[http://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.04.0057%3Aalphabetic+letter%3D*g%3Aentry+group%3D14%3Aentry%3Dgewdaisi%2Fa]
