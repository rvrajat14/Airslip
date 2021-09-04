//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BankTypeResponse: APIModel {

    public var id: String?

    public var links: [Link]?

    public var name: String?

    public init(id: String? = nil, links: [Link]? = nil, name: String? = nil) {
        self.id = id
        self.links = links
        self.name = name
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        id = try container.decodeIfPresent("id")
        links = try container.decodeArrayIfPresent("links")
        name = try container.decodeIfPresent("name")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(links, forKey: "links")
        try container.encodeIfPresent(name, forKey: "name")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? BankTypeResponse else { return false }
      guard self.id == object.id else { return false }
      guard self.links == object.links else { return false }
      guard self.name == object.name else { return false }
      return true
    }

    public static func == (lhs: BankTypeResponse, rhs: BankTypeResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
