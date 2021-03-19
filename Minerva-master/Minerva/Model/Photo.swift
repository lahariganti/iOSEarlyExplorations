//
//  Photo.swift
//  Minerva
//
//  Created by Lahari Ganti on 6/16/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import Foundation

typealias Photos = [Photo]

class Photo: Codable {
    let id: String?
    let createdAt: String?
    let width, height: Int?
    let color: String?
    let likes: Int?
    let likedByUser: Bool?
    let user: User?
    let currentUserCollections: [JSONAny]?
    let urls: Urls?
    let categories: [Category]?
    let links: PhotoLinks?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color, likes
        case likedByUser = "liked_by_user"
        case user
        case currentUserCollections = "current_user_collections"
        case urls, categories, links
    }

    init(id: String?, createdAt: String?, width: Int?, height: Int?, color: String?, likes: Int?, likedByUser: Bool?, user: User?, currentUserCollections: [JSONAny]?, urls: Urls?, categories: [Category]?, links: PhotoLinks?) {
        self.id = id
        self.createdAt = createdAt
        self.width = width
        self.height = height
        self.color = color
        self.likes = likes
        self.likedByUser = likedByUser
        self.user = user
        self.currentUserCollections = currentUserCollections
        self.urls = urls
        self.categories = categories
        self.links = links
    }

    static func parsePhotos(photos: Photos) -> Photos {
        var newPhotos = [Photo]()
        for photo in photos {
            let newPhoto = Photo(id: photo.id,
                                 createdAt: photo.createdAt,
                                 width: photo.width,
                                 height: photo.height,
                                 color: photo.color,
                                 likes: photo.likes,
                                 likedByUser: photo.likedByUser,
                                 user: photo.user,
                                 currentUserCollections: photo.currentUserCollections,
                                 urls: photo.urls,
                                 categories: photo.categories,
                                 links: photo.links)
            newPhotos.append(newPhoto)
        }
        return newPhotos
    }
}

class Category: Codable {
    let id: Int?
    let title: Title?
    let photoCount: Int?
    let links: CategoryLinks?

    enum CodingKeys: String, CodingKey {
        case id, title
        case photoCount = "photo_count"
        case links
    }

    init(id: Int?, title: Title?, photoCount: Int?, links: CategoryLinks?) {
        self.id = id
        self.title = title
        self.photoCount = photoCount
        self.links = links
    }
}

class CategoryLinks: Codable {
    let linksSelf, photos: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case photos
    }

    init(linksSelf: String?, photos: String?) {
        self.linksSelf = linksSelf
        self.photos = photos
    }
}

enum Title: String, Codable {
    case buildings = "Buildings"
    case nature = "Nature"
    case objects = "Objects"
    case people = "People"
}

class PhotoLinks: Codable {
    let linksSelf: String?
    let html, download: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }

    init(linksSelf: String?, html: String?, download: String?) {
        self.linksSelf = linksSelf
        self.html = html
        self.download = download
    }
}

class Urls: Codable {
    let raw, full, regular, small: String?
    let thumb: String?

    init(raw: String?, full: String?, regular: String?, small: String?, thumb: String?) {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}

class User: Codable {
    let id, username, name: String?
    let profileImage: ProfileImage?
    let links: UserLinks?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case profileImage = "profile_image"
        case links
    }

    init(id: String?, username: String?, name: String?, profileImage: ProfileImage?, links: UserLinks?) {
        self.id = id
        self.username = username
        self.name = name
        self.profileImage = profileImage
        self.links = links
    }
}

class UserLinks: Codable {
    let linksSelf: String?
    let html: String?
    let photos, likes: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes
    }

    init(linksSelf: String?, html: String?, photos: String?, likes: String?) {
        self.linksSelf = linksSelf
        self.html = html
        self.photos = photos
        self.likes = likes
    }
}


class ProfileImage: Codable {
    let small, medium, large: String?

    init(small: String?, medium: String?, large: String?) {
        self.small = small
        self.medium = medium
        self.large = large
    }
}


class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {

    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
