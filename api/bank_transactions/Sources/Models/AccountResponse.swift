//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class AccountResponse: APIModel {

    public var accountNickname: String?

    public var accountNumber: String?

    public var accountType: String?

    public var bank: BankAccountResponse?

    public var currencyCode: String?

    public var id: String?

    public var lastCardDigits: String?

    public var links: [Link]?

    public var sortCode: String?

    public var usageType: String?

    public init(accountNickname: String? = nil, accountNumber: String? = nil, accountType: String? = nil, bank: BankAccountResponse? = nil, currencyCode: String? = nil, id: String? = nil, lastCardDigits: String? = nil, links: [Link]? = nil, sortCode: String? = nil, usageType: String? = nil) {
        self.accountNickname = accountNickname
        self.accountNumber = accountNumber
        self.accountType = accountType
        self.bank = bank
        self.currencyCode = currencyCode
        self.id = id
        self.lastCardDigits = lastCardDigits
        self.links = links
        self.sortCode = sortCode
        self.usageType = usageType
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        accountNickname = try container.decodeIfPresent("accountNickname")
        accountNumber = try container.decodeIfPresent("accountNumber")
        accountType = try container.decodeIfPresent("accountType")
        bank = try container.decodeIfPresent("bank")
        currencyCode = try container.decodeIfPresent("currencyCode")
        id = try container.decodeIfPresent("id")
        lastCardDigits = try container.decodeIfPresent("lastCardDigits")
        links = try container.decodeArrayIfPresent("links")
        sortCode = try container.decodeIfPresent("sortCode")
        usageType = try container.decodeIfPresent("usageType")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(accountNickname, forKey: "accountNickname")
        try container.encodeIfPresent(accountNumber, forKey: "accountNumber")
        try container.encodeIfPresent(accountType, forKey: "accountType")
        try container.encodeIfPresent(bank, forKey: "bank")
        try container.encodeIfPresent(currencyCode, forKey: "currencyCode")
        try container.encodeIfPresent(id, forKey: "id")
        try container.encodeIfPresent(lastCardDigits, forKey: "lastCardDigits")
        try container.encodeIfPresent(links, forKey: "links")
        try container.encodeIfPresent(sortCode, forKey: "sortCode")
        try container.encodeIfPresent(usageType, forKey: "usageType")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? AccountResponse else { return false }
      guard self.accountNickname == object.accountNickname else { return false }
      guard self.accountNumber == object.accountNumber else { return false }
      guard self.accountType == object.accountType else { return false }
      guard self.bank == object.bank else { return false }
      guard self.currencyCode == object.currencyCode else { return false }
      guard self.id == object.id else { return false }
      guard self.lastCardDigits == object.lastCardDigits else { return false }
      guard self.links == object.links else { return false }
      guard self.sortCode == object.sortCode else { return false }
      guard self.usageType == object.usageType else { return false }
      return true
    }

    public static func == (lhs: AccountResponse, rhs: AccountResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
