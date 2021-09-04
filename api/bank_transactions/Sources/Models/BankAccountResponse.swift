//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BankAccountResponse: APIModel {

    public var icon: String?

    public var id: String?

    public var logo: String?

    public var name: String?

    public init(icon: String? = nil, id: String? = nil, logo: String? = nil, name: String? = nil) {
        self.icon = icon
        self.id = id
        self.logo = logo
        self.name = name
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        icon = try container.decodeIfPresent("icon")
        id = try container.decodeIfPresent("id")
        logo = try container.decodeIfPresent("logo")
        name = try container.decodeIfPresent("name")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(icon, forKey: "icon")
        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(logo, forKey: "logo")
        try container.encodeIfPresent(name, forKey: "name")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? BankAccountResponse else { return false }
      guard self.icon == object.icon else { return false }
      guard self.id == object.id else { return false }
      guard self.logo == object.logo else { return false }
      guard self.name == object.name else { return false }
      return true
    }

    public static func == (lhs: BankAccountResponse, rhs: BankAccountResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
