//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ProductCareTipsRequest: APIModel {

    public var descriptions: [String]?

    public init(descriptions: [String]? = nil) {
        self.descriptions = descriptions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        descriptions = try container.decodeArrayIfPresent("descriptions")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(descriptions, forKey: "descriptions")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ProductCareTipsRequest else { return false }
      guard self.descriptions == object.descriptions else { return false }
      return true
    }

    public static func == (lhs: ProductCareTipsRequest, rhs: ProductCareTipsRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
