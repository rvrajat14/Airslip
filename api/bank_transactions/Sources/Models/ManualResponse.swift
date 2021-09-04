//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ManualResponse: APIModel {

    public var links: [Link]?

    public var manualUrl: String?

    public var merchantName: String?

    public var productImageUrl: String?

    public var productItem: String?

    public init(links: [Link]? = nil, manualUrl: String? = nil, merchantName: String? = nil, productImageUrl: String? = nil, productItem: String? = nil) {
        self.links = links
        self.manualUrl = manualUrl
        self.merchantName = merchantName
        self.productImageUrl = productImageUrl
        self.productItem = productItem
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        links = try container.decodeArrayIfPresent("links")
        manualUrl = try container.decodeIfPresent("manualUrl")
        merchantName = try container.decodeIfPresent("merchantName")
        productImageUrl = try container.decodeIfPresent("productImageUrl")
        productItem = try container.decodeIfPresent("productItem")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(links, forKey: "links")
        try container.encodeIfPresent(manualUrl, forKey: "manualUrl")
        try container.encodeIfPresent(merchantName, forKey: "merchantName")
        try container.encodeIfPresent(productImageUrl, forKey: "productImageUrl")
        try container.encodeIfPresent(productItem, forKey: "productItem")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ManualResponse else { return false }
      guard self.links == object.links else { return false }
      guard self.manualUrl == object.manualUrl else { return false }
      guard self.merchantName == object.merchantName else { return false }
      guard self.productImageUrl == object.productImageUrl else { return false }
      guard self.productItem == object.productItem else { return false }
      return true
    }

    public static func == (lhs: ManualResponse, rhs: ManualResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}