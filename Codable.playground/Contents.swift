//: Playground - noun: a place where people can play

import UIKit

//https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375

struct Swifter: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
    let weibi: String?
}

let json = """
{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr"
}
""".data(using: .utf8)! // our data in native (JSON) format
let myStruct = try JSONDecoder().decode(Swifter.self, from: json) // Decoding our data
print(myStruct) // decoded!!!!!
