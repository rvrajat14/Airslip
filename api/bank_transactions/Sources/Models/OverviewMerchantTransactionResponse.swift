//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class OverviewMerchantTransactionResponse: APIModel {

    public var icon: String?

    public var isSupported: Bool?

    public var name: String?

    public init(icon: String? = nil, isSupported: Bool? = nil, name: String? = nil) {
        self.icon = icon
        self.isSupported = isSupported
        self.name = name
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        icon = try container.decodeIfPresent("icon")
        isSupported = try container.decodeIfPresent("isSupported")
        name = try container.decodeIfPresent("name")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(icon, forKey: "icon")
        try container.encodeIfPresent(isSupported, forKey: "isSupported")
        try container.encodeIfPresent(name, forKey: "name")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? OverviewMerchantTransactionResponse else { return false }
      guard self.icon == object.icon else { return false }
      guard self.isSupported == object.isSupported else { return false }
      guard self.name == object.name else { return false }
      return true
    }

    public static func == (lhs: OverviewMerchantTransactionResponse, rhs: OverviewMerchantTransactionResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}