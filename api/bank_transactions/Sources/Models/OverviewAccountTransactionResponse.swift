//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class OverviewAccountTransactionResponse: APIModel {

    public var amount: String?

    public var authorisedDate: String?

    public var authorisedTime: String?

    public var bankTransactionId: String?

    public var capturedDate: String?

    public var capturedTime: String?

    public var currencyCode: String?

    public var currencySymbol: String?

    public var description: String?

    public var institutionId: String?

    public var isoFamilyCode: String?

    public var links: [Link]?

    public var merchant: OverviewMerchantTransactionResponse?

    public var merchantTransactionId: String?

    public var proprietaryCode: String?

    public init(amount: String? = nil, authorisedDate: String? = nil, authorisedTime: String? = nil, bankTransactionId: String? = nil, capturedDate: String? = nil, capturedTime: String? = nil, currencyCode: String? = nil, currencySymbol: String? = nil, description: String? = nil, institutionId: String? = nil, isoFamilyCode: String? = nil, links: [Link]? = nil, merchant: OverviewMerchantTransactionResponse? = nil, merchantTransactionId: String? = nil, proprietaryCode: String? = nil) {
        self.amount = amount
        self.authorisedDate = authorisedDate
        self.authorisedTime = authorisedTime
        self.bankTransactionId = bankTransactionId
        self.capturedDate = capturedDate
        self.capturedTime = capturedTime
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
        self.description = description
        self.institutionId = institutionId
        self.isoFamilyCode = isoFamilyCode
        self.links = links
        self.merchant = merchant
        self.merchantTransactionId = merchantTransactionId
        self.proprietaryCode = proprietaryCode
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        amount = try container.decodeIfPresent("amount")
        authorisedDate = try container.decodeIfPresent("authorisedDate")
        authorisedTime = try container.decodeIfPresent("authorisedTime")
        bankTransactionId = try container.decodeIfPresent("bankTransactionId")
        capturedDate = try container.decodeIfPresent("capturedDate")
        capturedTime = try container.decodeIfPresent("capturedTime")
        currencyCode = try container.decodeIfPresent("currencyCode")
        currencySymbol = try container.decodeIfPresent("currencySymbol")
        description = try container.decodeIfPresent("description")
        institutionId = try container.decodeIfPresent("institutionId")
        isoFamilyCode = try container.decodeIfPresent("isoFamilyCode")
        links = try container.decodeArrayIfPresent("links")
        merchant = try container.decodeIfPresent("merchant")
        merchantTransactionId = try container.decodeIfPresent("merchantTransactionId")
        proprietaryCode = try container.decodeIfPresent("proprietaryCode")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(amount, forKey: "amount")
        try container.encodeIfPresent(authorisedDate, forKey: "authorisedDate")
        try container.encodeIfPresent(authorisedTime, forKey: "authorisedTime")
        try container.encodeIfPresent(bankTransactionId, forKey: "bankTransactionId")
        try container.encodeIfPresent(capturedDate, forKey: "capturedDate")
        try container.encodeIfPresent(capturedTime, forKey: "capturedTime")
        try container.encodeIfPresent(currencyCode, forKey: "currencyCode")
        try container.encodeIfPresent(currencySymbol, forKey: "currencySymbol")
        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(institutionId, forKey: "institutionId")
        try container.encodeIfPresent(isoFamilyCode, forKey: "isoFamilyCode")
        try container.encodeIfPresent(links, forKey: "links")
        try container.encodeIfPresent(merchant, forKey: "merchant")
        try container.encodeIfPresent(merchantTransactionId, forKey: "merchantTransactionId")
        try container.encodeIfPresent(proprietaryCode, forKey: "proprietaryCode")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? OverviewAccountTransactionResponse else { return false }
      guard self.amount == object.amount else { return false }
      guard self.authorisedDate == object.authorisedDate else { return false }
      guard self.authorisedTime == object.authorisedTime else { return false }
      guard self.bankTransactionId == object.bankTransactionId else { return false }
      guard self.capturedDate == object.capturedDate else { return false }
      guard self.capturedTime == object.capturedTime else { return false }
      guard self.currencyCode == object.currencyCode else { return false }
      guard self.currencySymbol == object.currencySymbol else { return false }
      guard self.description == object.description else { return false }
      guard self.institutionId == object.institutionId else { return false }
      guard self.isoFamilyCode == object.isoFamilyCode else { return false }
      guard self.links == object.links else { return false }
      guard self.merchant == object.merchant else { return false }
      guard self.merchantTransactionId == object.merchantTransactionId else { return false }
      guard self.proprietaryCode == object.proprietaryCode else { return false }
      return true
    }

    public static func == (lhs: OverviewAccountTransactionResponse, rhs: OverviewAccountTransactionResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
