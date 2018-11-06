import UIKit

/**
 # Stefan Reip
 */
let myName = "Stefan Reip"

// Swift Basics
//   datatypes: var vs. let, strings, split, numbers, lists, sets, dictionary
//   e.g. var smartphonePasscodeSequence="77,33,1,66".split(separator: ",")
print("Define and output your pets as set")
var pets = ["Alf", "Berta", "Clown"]
for pet in pets {
    print(" \(pet)")
}

print("\nDefine and output your last vacations as dictionaries")
var vacations: Dictionary = [String: String]()
vacations["August"] = "Grado (IT)"
vacations["Juni"] = "Bibione (IT)"

for vacation in vacations {
    print(" \(vacation.value) in \(vacation.key)")
}

//   datatypes: optionals, optional chaining, enums
print("\nDefine and use a dbUrlString which might be nil")
var dbUrlString:String?
dbUrlString = dbUrlString?.uppercased()
dbUrlString = "htts://database.domain.COM"
dbUrlString = dbUrlString?.lowercased()

//   optional chaining:
print("Output the db connection string (lowercase) only if not nil")
//   e.g.: if let txt = dbConnectionStg?.lowercased() { ...
if (nil != dbUrlString) {
    print(" \(dbUrlString!)")
}

print("\nDefine life-cyle states of a smartphone app as enum")
//   e.g.: print( SmartPhone.LifeCycle.Paused )
enum SmartPhone {
    enum LifeCycle {
        case Stopped, Inactive, Active, Background, Suspended
    }
}

print(" \(SmartPhone.LifeCycle.Active)")


//   format strings <= string interpolation
print("\nThe length of \(myName) is \(myName.count) chars.") // TODO fill in your variables

//   functions: inout parameters (to save mem) and variable number of arguments (...)
print("\nDefine a function which modifies every given string by removing a random character...")

func removeRandomCharacter( param: inout String) {
    let rand = Int.random(in: 0 ... param.count)
    let index = param.index(param.startIndex, offsetBy: rand, limitedBy: param.endIndex)
    if (index != nil) {
        param.remove(at: index!)
    }
}
var abc = "abcdefghijklmnopqrstuvwxyz"
removeRandomCharacter(param: &abc)
print(" \(abc)")

//   functions: named parameters with default values and multiple return values for more semantics
print("\nDefine and use multiple times a function which moves a player around in 3D space ...")
//   e.g.: player.magicMove(to: acceleratedBy: exploding: reappearWithColor: ....)
struct position {
    var x:Int
    var y:Int
    var z:Int
}
struct player {
    var pos:position
    var hexColor:String
    
    mutating func magicMove(to: position, reappearWithHexColor:String) -> position {
        pos = to;
        hexColor = reappearWithHexColor;
        return pos
    }
}
let pos1 = position(x: 0, y: 0, z: 0)
var p1 = player(pos: pos1, hexColor: "#FFFFFF")
let pos2 = position(x: 5, y: -3, z: 8)
let pos3 = position(x: 23, y: 10, z: 4)
let pos4 = position(x: 7, y: 14, z: 9)
p1.magicMove(to: pos2, reappearWithHexColor: "#000000")
p1.magicMove(to: pos3, reappearWithHexColor: "#111111")
p1.magicMove(to: pos4, reappearWithHexColor: "#222222")

print(" \(p1)")

//   oo basics: classes
//   oo basics: properties
//   oo basics: privacy = visibility = (default) access levels <= read "Access Control in the Language Guide)
//   oo advanced: protocols = the API
print("\nDefine a protocol which allows to retrieve location-info from an object")
//   e.g. methods: .getGPSLocation getDistanceFromHere
protocol Location {
    var lat:Double {get set}
    var lon:Double {get set}
    var getGPSLocation: Array<Double> { get }
    func getDistanceFromHere(lat:Double!, lon:Double!) -> Double
}
public class House: Location {
   
    var lat:Double
    
    var lon:Double
    
    public init() {
        self.lat = 0.0
        self.lon = 0.0
    }
    
    public init(lat:Double, lon:Double) {
        self.lat = lat
        self.lon = lon
    }
    
    
    var getGPSLocation: Array<Double> {
        return [self.lat, self.lon]
    }
    
    func getDistanceFromHere(lat: Double!, lon: Double!) -> Double {
        // Some dummy implementation. Doesn't work correctly
        return (self.lat-lat + self.lon-lon)
    }
}

var ourHouse = House(lat: 3.14, lon: 15.92)
print(" coordinates of ourHouse \(ourHouse.getGPSLocation)")
print(" distance from here \(abs(ourHouse.getDistanceFromHere(lat: 47.36, lon: 15.09)))")

//   oo advanced: inheritance
print("\nModel and create at least 7 point-of-interests (POIs)")
//   e.g.: sight seeing locations in austria with longitude/latidude, image and ...
public class POI: Location {
    var lat: Double
    
    var lon: Double
    
    /**Path to image*/
    var image: String?
    
    var getGPSLocation: Array<Double> {
        return [self.lat, self.lon]
    }
    
    public init() {
        self.lat = 0.0
        self.lon = 0.0
    }
    
    public init(lat:Double, lon:Double, image:String?) {
        self.lat = lat
        self.lon = lon
        self.image = image
    }
    
    func getDistanceFromHere(lat: Double!, lon: Double!) -> Double {
        return (self.lat-lat + self.lon-lon)
    }
    
    func prettyPrint() {
        var obj:String = " "
        obj += " lat: \(lat)"
        obj += " lon: \(lon)"
        if (image != nil) {
            obj += " image: \(image ?? "")"
        }
        print(obj)
    }
    
    
}
POI(lat: 1.6, lon: 2.0, image: "http://example.com/img/0.jpg").prettyPrint()
POI(lat: 2.5, lon: 2.1, image: "http://example.com/img/1.jpg").prettyPrint()
POI(lat: 3.4, lon: 2.2, image: "http://example.com/img/2.jpg").prettyPrint()
POI(lat: 4.3, lon: 2.3, image: nil).prettyPrint()
POI(lat: 5.2, lon: 2.4, image: "http://example.com/img/4.jpg").prettyPrint()
POI(lat: 6.1, lon: 2.5, image: "http://example.com/img/5.jpg").prettyPrint()
POI(lat: 7.0, lon: 2.6, image: "http://example.com/img/6.jpg").prettyPrint()


print("\nSpecialise Pub-POIs with convenience initialisers (list of available drinks)...")
//   e.g.: irish pubs in graz with longitude/latidude, image and available drinks...
public class Pub:POI {
    
    var drinks:Array<String>?
    
    override public init() {
        super.init()
    }
    
    public init(lat:Double, lon:Double, image:String?, drinks:Array<String>?) {
        super.init(lat: lat, lon: lon, image: image)
        self.drinks = drinks
    }
    
    override func prettyPrint() {
        var obj:String = " "
        obj += " lat: \(super.lat)"
        obj += " lon: \(super.lon)"
        if (super.image != nil) {
            obj += " image: \(super.image ?? "")"
        }
        if (self.drinks != nil) {
            obj += " drinks: \(self.drinks ?? [])"
        }
        print(obj)
    }
}

Pub(lat: 2.5, lon: 2.1, image: "http://example.com/img/1.jpg", drinks: ["Beer", "Whiskey"]).prettyPrint()
Pub(lat: 3.4, lon: 2.2, image: "http://example.com/img/2.jpg", drinks: nil).prettyPrint()
Pub(lat: 4.3, lon: 2.3, image: nil, drinks: nil).prettyPrint()

//   oo advanced: extend class
print("\nExtend the String class with a new function padding (allow to specify indent and char)")
//   e.g.: print( myname.padding(indent:3, char:"_") )
extension String {
    mutating func padding (indent:Int, char:Character) {
        var pad:String = ""
        for _ in 1...indent {
            pad += String(char)
        }
        self = pad + self
    }
}
var stringWithoutPadding:String = "Blabla123Test"
stringWithoutPadding.padding(indent: 3, char: "_")
print(stringWithoutPadding)


//   docu <= see https://www.appcoda.com/swift-markdown/
/// This is helpful if you ALT-Click on the varialbe or function:
let author="jf";
/** This documentation needs some rework
 - parameter bA: The author
 */
func about(lastmodified lm: Int = 2017, byAuthor bA: String  )->String{
    return "\(lm) by \(bA)" }
print( about( lastmodified: 2018, byAuthor: "jf") )



//   functional: closures, map, reduce, filter, joined sorted ...
//  see https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html where you learn that
//  ... Closures are self-contained blocks of functionality that can be passed around... { (parameters) -> return type in statements } ...
//  e.g. a rather long version (TODO learn to shorten it!):
func backward(_ s1: String, _ s2: String) -> Bool { return s1 > s2 }
var reversedNames = ["Hello","IMS"].sorted(by: backward)
print("\nCreate and output list of image-names sorted by png, jpg, gif .. suffix")

var images = ["hallo.png", "wald.jpg", "giphy.gif", "foo.png", "bar.jpg", "longname.png"]
print(images.sorted{$0.split(separator: ".")[1] < $1.split(separator: ".")[1]})

print("\nThen output list of gif image-names")
print(images.filter{$0.split(separator: ".")[1] == "gif"})

print("\nThen output the overall char-count of the jpg image-names")
print(images.filter{$0.split(separator: ".")[1] == "jpg"}.joined().count)

print("\nThen output sorted list of very short (<5 chars) png image-names uppercased")
print(images.filter{$0.split(separator: ".")[1] == "png"}.filter{$0.split(separator: ".")[0].count < 5}.joined().uppercased())



// variable
var str = "Hello, playground"

// const
let str1 = "Always hello"
// so this doesn't work:
//str1 = "test"

let value = 0.0
let coordinatesString = "47.45320642623578,15.331996110929875"
let coordinates = coordinatesString.split(separator: ",")
print(coordinates)
let lat:Double = Double(coordinates[0])!
let lon:Double = Double(coordinates[1])!
print("Latitude:  \(String(format:"%f", lat)) \nLongitude: \(String(format:"%f", lon))")
