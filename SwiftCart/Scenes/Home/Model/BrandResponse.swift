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

// MARK: - Brand
struct Brand: Codable {
    let id: Int?
    let handle, title: String?
    let bodyHTML: String?
    let sortOrder: String?
    let disjunctive: Bool?
    let publishedScope, adminGraphqlAPIID: String?
    let image: BrandImage?

    enum CodingKeys: String, CodingKey {
        case id, handle, title
        case bodyHTML = "body_html"
        case sortOrder = "sort_order"
        case disjunctive
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}

// MARK: - BrandImage
struct BrandImage: Codable {
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
