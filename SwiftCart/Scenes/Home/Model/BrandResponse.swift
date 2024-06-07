//
//  BrandResponse.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//

import Foundation

struct BrandResponse: Codable {
    let brands: [Brand]?

    enum CodingKeys: String, CodingKey {
        case brands = "smart_collections"
    }
}

// MARK: - SmartCollection
struct Brand: Codable {
    let id: Int?
    let handle, title: String?
    //let updatedAt: Date?
    let bodyHTML: String?
    //let publishedAt: Date?
    let sortOrder: String?
    //let templateSuffix: JSONNull?
    let disjunctive: Bool?
    //let rules: [Rule]?
    let publishedScope, adminGraphqlAPIID: String?
    let image: Image?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
        //case updatedAt = "updated_at"
        case bodyHTML = "body_html"
        //case publishedAt = "published_at"
        case sortOrder = "sort_order"
        //case templateSuffix = "template_suffix"
        case disjunctive
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}

// MARK: - Image
struct Image: Codable {
    let createdAt: Date?
    let alt: JSONNull?
    let width, height: Int?
    let src: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case alt, width, height, src
    }
}

// MARK: - Rule
struct Rule: Codable {
    let column, relation, condition: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
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
