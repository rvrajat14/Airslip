//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ProductVideoTutorialResponse: APIModel {

    public var description: String?

    public var url: String?

    public init(description: String? = nil, url: String? = nil) {
        self.description = description
        self.url = url
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        description = try container.decodeIfPresent("description")
        url = try container.decodeIfPresent("url")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(url, forKey: "url")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ProductVideoTutorialResponse else { return false }
      guard self.description == object.description else { return false }
      guard self.url == object.url else { return false }
      return true
    }

    public static func == (lhs: ProductVideoTutorialResponse, rhs: ProductVideoTutorialResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}