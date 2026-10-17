//
//  FormURLEncoder.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 07.10.2026.
//

import Foundation

enum FormURLEncoder {
    private static let allowed = CharacterSet(
        charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    )

    static func encode(_ fields: [String: String]) -> Data {
        let body = fields
            .map { key, value in
                "\(percentEncoded(key))=\(percentEncoded(value))"
            }
            .joined(separator: "&")
        return Data(body.utf8)
    }

    static func encode(key: String, values: [String]) -> Data {
        let body = values
            .map { "\(percentEncoded(key))=\(percentEncoded($0))" }
            .joined(separator: "&")
        return Data(body.utf8)
    }

    static func encodeEmptyArray(key: String) -> Data {
        Data("\(percentEncoded(key))[]=".utf8)
    }

    private static func percentEncoded(_ value: String) -> String {
        value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
    }
}
