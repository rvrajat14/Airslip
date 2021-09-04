//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class RetryTransactionIndexingRequest: APIModel {

    public var correlationId: String?

    public var metadata: [String: String]?

    public init(correlationId: String? = nil, metadata: [String: String]? = nil) {
        self.correlationId = correlationId
        self.metadata = metadata
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        correlationId = try container.decodeIfPresent("correlationId")
        metadata = try container.decodeIfPresent("metadata")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(correlationId, forKey: "correlationId")
        try container.encodeIfPresent(metadata, forKey: "metadata")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? RetryTransactionIndexingRequest else { return false }
      guard self.correlationId == object.correlationId else { return false }
      guard self.metadata == object.metadata else { return false }
      return true
    }

    public static func == (lhs: RetryTransactionIndexingRequest, rhs: RetryTransactionIndexingRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}