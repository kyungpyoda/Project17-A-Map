//
//  JsonPlace.swift
//  NaverMapA
//
//  Created by 홍경표 on 2020/11/19.
//

import Foundation

struct JsonPlace {
    var id: String
    var name: String
    var longitude: Double
    var latitude: Double
    var imageUrl: String?
    var category: String
}

extension JsonPlace: Decodable {
    enum CodingKeys: String, CodingKey {
        case longitude = "x"
        case latitude = "y"
        case id, name, imageUrl, category
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(String.self, forKey: .id)
        self.longitude = Double(try container.decode(String.self, forKey: .longitude)) ?? JsonPlaceInputGuideNumber.zero.rawValue
        self.latitude = Double(try container.decode(String.self, forKey: .latitude)) ?? JsonPlaceInputGuideNumber.zero.rawValue
        self.imageUrl = try container.decode(String?.self, forKey: .imageUrl)
        self.category = try container.decode(String.self, forKey: .category)
    }
    func distanceTo(_ jsonPlace: JsonPlace) -> Double {
        return sqrt(pow(latitude - jsonPlace.latitude, 2) + pow(longitude - jsonPlace.longitude, 2))
    }
    static func centroid(of jsonPlaces: [JsonPlace]) -> JsonPlace {
        let sum: (longitude: Double, latitude: Double) = jsonPlaces.reduce(
            (0.0, 0.0), {($0.0 + $1.longitude, $0.1 + $1.latitude)}
        )
        let centerLng = sum.longitude / Double(jsonPlaces.count)
        let centerLat = sum.latitude / Double(jsonPlaces.count)
        return JsonPlace(id: "", name: "", longitude: centerLng, latitude: centerLat, imageUrl: "", category: "")
    }
}

extension JsonPlace {
    enum JsonPlaceInputGuideNumber: Double {
        case zero = 0
    }
    enum JsonPlaceInputGuideString: String {
        case blank = ""
    }
}

extension JsonPlace: Equatable {
    
}