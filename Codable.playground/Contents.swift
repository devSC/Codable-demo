//: Playground - noun: a place where people can play

import UIKit

//https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375

struct Swifter: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
    let weibi: String?
}

var json = """
{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr"
}
""".data(using: .utf8)! // our data in native (JSON) format
let myStruct = try JSONDecoder().decode(Swifter.self, from: json) // Decoding our data
print(myStruct) // decoded!!!!!


struct Swifter2 {
    let fullName: String
    let id: Int
    let twitter: URL
    let weibo: String?
}


///Custom decodable
extension Swifter2: Decodable {
    enum CodingKeys: String, CodingKey {
        case fullName = "fullName"
        case id = "id"
        case twitter = "twitter"
        case weibo = "weibo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fullName = try container.decode(String.self, forKey: .fullName)
        let id = try container.decode(Int.self, forKey: .id)
        let twitter = try container.decode(URL.self, forKey: .twitter)
        let weibo = try container.decodeIfPresent(String.self, forKey: .weibo)
        self.init(fullName: fullName, id: id, twitter: twitter, weibo: weibo)
    }
}

//encode

extension Swifter2: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fullName, forKey: .fullName)
        try container.encode(id, forKey: .id)
        try container.encode(twitter, forKey: .twitter)
        try container.encodeIfPresent(weibo, forKey: .weibo)
    }
}

var myStruct2: Swifter2?
do {
    myStruct2 = try JSONDecoder().decode(Swifter2.self, from: json) // Decoding our data
} catch DecodingError.typeMismatch(let type, let context) {
    print("type: \(type), context: \(context)")
} catch DecodingError.valueNotFound(let type, let context) {
    print("type: \(type), context: \(context)")
} catch {
    print(error.localizedDescription)
}
if let myStruct = myStruct2 {
    print(myStruct) // decoded!!!!!
    
    ///encode
    let structJson = try JSONEncoder().encode(myStruct)
    let newStruct = try JSONDecoder().decode(Swifter2.self, from: structJson) // Decoding our data
    print("newStruct: \(newStruct)")
}


///Decode a set
json = """
[{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr"
},{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr"
},{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr",
 "weibo": "123"
}]
""".data(using: .utf8)! // our data in native format

do {
    let myStructArray = try JSONDecoder().decode([Swifter2].self, from: json)
    myStructArray.forEach { print($0) } // decoded!!!!!
} catch {
    print(error.localizedDescription)
}


///Decode a Dictionary
json = """
{
  "one": {
    "fullName": "Federico Zanetello",
    "id": 123456,
    "twitter": "http://twitter.com/zntfdr"
  },
  "two": {
    "fullName": "Federico Zanetello",
    "id": 123456,
    "twitter": "http://twitter.com/zntfdr"
  },
  "three": {
    "fullName": "Federico Zanetello",
    "id": 123456,
    "twitter": "http://twitter.com/zntfdr"
  }
}
""".data(using: .utf8)! // our data in native format

do {
    let myStructDictionary = try JSONDecoder().decode([String: Swifter].self, from: json)
    myStructDictionary.forEach { print("\($0.key): \($0.value)") } // decoded!!!!!
} catch {
    print(error.localizedDescription)
}


///Enum
enum SwifterOrBool {
    case swifter(Swifter)
    case bool(Bool)
}

extension SwifterOrBool: Decodable {
    enum CodingKeys: String, CodingKey {
        case swifter, bool
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let swifter = try container.decodeIfPresent(Swifter.self, forKey: .swifter) {
            self = .swifter(swifter)
        } else {
            self = .bool(try container.decode(Bool.self, forKey: .bool))
        }
    }
}

json = """
[{
"swifter": {
   "fullName": "Federico Zanetello",
   "id": 123456,
   "twitter": "http://twitter.com/zntfdr"
  }
},
{ "bool": true },
{ "bool": false },
{
"swifter": {
   "fullName": "Federico Zanetello",
   "id": 123456,
   "twitter": "http://twitter.com/zntfdr"
  }
}]
""".data(using: .utf8)! // our native (JSON) data

let myEnumArray = try JSONDecoder().decode([SwifterOrBool].self, from: json) // decoding our data
myEnumArray.forEach { print($0) } // decoded!


///Complex Struct
struct MoreComplexStruct: Decodable {
    let swifter: Swifter
    let lovesSwift: Bool
}

json = """
{
    "swifter": {
        "fullName": "Federico Zanetello",
        "id": 123456,
        "twitter": "http://twitter.com/zntfdr"
    },
    "lovesSwift": true
}
""".data(using: .utf8)! // our data in native format

let myMoreComplexStruct = try JSONDecoder().decode(MoreComplexStruct.self, from: json)
print(myMoreComplexStruct.swifter) // decoded!!!!!

