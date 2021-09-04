//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ProductResponse: APIModel {

    public var amountSubtotal: String?

    public var amountTotal: String?

    public var currencySymbol: String?

    public var description: String?

    public var dimensions: String?

    public var ean: String?

    public var imageUrl: String?

    public var item: String?

    public var manualUrl: String?

    public var manufacturer: String?

    public var modelNumber: String?

    public var productUrl: String?

    public var quantity: Int?

    public var releaseDate: DateTime?

    public var sku: String?

    public var upc: String?

    public var vatRate: [String: Double]?

    public var videoTutorials: [ProductVideoTutorialResponse]?

    public var warrantyExpiryDateTime: String?

    public var warrantyText: String?

    public init(amountSubtotal: String? = nil, amountTotal: String? = nil, currencySymbol: String? = nil, description: String? = nil, dimensions: String? = nil, ean: String? = nil, imageUrl: String? = nil, item: String? = nil, manualUrl: String? = nil, manufacturer: String? = nil, modelNumber: String? = nil, productUrl: String? = nil, quantity: Int? = nil, releaseDate: DateTime? = nil, sku: String? = nil, upc: String? = nil, vatRate: [String: Double]? = nil, videoTutorials: [ProductVideoTutorialResponse]? = nil, warrantyExpiryDateTime: String? = nil, warrantyText: String? = nil) {
        self.amountSubtotal = amountSubtotal
        self.amountTotal = amountTotal
        self.currencySymbol = currencySymbol
        self.description = description
        self.dimensions = dimensions
        self.ean = ean
        self.imageUrl = imageUrl
        self.item = item
        self.manualUrl = manualUrl
        self.manufacturer = manufacturer
        self.modelNumber = modelNumber
        self.productUrl = productUrl
        self.quantity = quantity
        self.releaseDate = releaseDate
        self.sku = sku
        self.upc = upc
        self.vatRate = vatRate
        self.videoTutorials = videoTutorials
        self.warrantyExpiryDateTime = warrantyExpiryDateTime
        self.warrantyText = warrantyText
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        amountSubtotal = try container.decodeIfPresent("amountSubtotal")
        amountTotal = try container.decodeIfPresent("amountTotal")
        currencySymbol = try container.decodeIfPresent("currencySymbol")
        description = try container.decodeIfPresent("description")
        dimensions = try container.decodeIfPresent("dimensions")
        ean = try container.decodeIfPresent("ean")
        imageUrl = try container.decodeIfPresent("imageUrl")
        item = try container.decodeIfPresent("item")
        manualUrl = try container.decodeIfPresent("manualUrl")
        manufacturer = try container.decodeIfPresent("manufacturer")
        modelNumber = try container.decodeIfPresent("modelNumber")
        productUrl = try container.decodeIfPresent("productUrl")
        quantity = try container.decodeIfPresent("quantity")
        releaseDate = try container.decodeIfPresent("releaseDate")
        sku = try container.decodeIfPresent("sku")
        upc = try container.decodeIfPresent("upc")
        vatRate = try container.decodeIfPresent("vatRate")
        videoTutorials = try container.decodeArrayIfPresent("videoTutorials")
        warrantyExpiryDateTime = try container.decodeIfPresent("warrantyExpiryDateTime")
        warrantyText = try container.decodeIfPresent("warrantyText")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(amountSubtotal, forKey: "amountSubtotal")
        try container.encodeIfPresent(amountTotal, forKey: "amountTotal")
        try container.encodeIfPresent(currencySymbol, forKey: "currencySymbol")
        try container.encodeIfPresent(description, forKey: "description")
        try container.encodeIfPresent(dimensions, forKey: "dimensions")
        try container.encodeIfPresent(ean, forKey: "ean")
        try container.encodeIfPresent(imageUrl, forKey: "imageUrl")
        try container.encodeIfPresent(item, forKey: "item")
        try container.encodeIfPresent(manualUrl, forKey: "manualUrl")
        try container.encodeIfPresent(manufacturer, forKey: "manufacturer")
        try container.encodeIfPresent(modelNumber, forKey: "modelNumber")
        try container.encodeIfPresent(productUrl, forKey: "productUrl")
        try container.encodeIfPresent(quantity, forKey: "quantity")
        try container.encodeIfPresent(releaseDate, forKey: "releaseDate")
        try container.encodeIfPresent(sku, forKey: "sku")
        try container.encodeIfPresent(upc, forKey: "upc")
        try container.encodeIfPresent(vatRate, forKey: "vatRate")
        try container.encodeIfPresent(videoTutorials, forKey: "videoTutorials")
        try container.encodeIfPresent(warrantyExpiryDateTime, forKey: "warrantyExpiryDateTime")
        try container.encodeIfPresent(warrantyText, forKey: "warrantyText")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ProductResponse else { return false }
      guard self.amountSubtotal == object.amountSubtotal else { return false }
      guard self.amountTotal == object.amountTotal else { return false }
      guard self.currencySymbol == object.currencySymbol else { return false }
      guard self.description == object.description else { return false }
      guard self.dimensions == object.dimensions else { return false }
      guard self.ean == object.ean else { return false }
      guard self.imageUrl == object.imageUrl else { return false }
      guard self.item == object.item else { return false }
      guard self.manualUrl == object.manualUrl else { return false }
      guard self.manufacturer == object.manufacturer else { return false }
      guard self.modelNumber == object.modelNumber else { return false }
      guard self.productUrl == object.productUrl else { return false }
      guard self.quantity == object.quantity else { return false }
      guard self.releaseDate == object.releaseDate else { return false }
      guard self.sku == object.sku else { return false }
      guard self.upc == object.upc else { return false }
      guard self.vatRate == object.vatRate else { return false }
      guard self.videoTutorials == object.videoTutorials else { return false }
      guard self.warrantyExpiryDateTime == object.warrantyExpiryDateTime else { return false }
      guard self.warrantyText == object.warrantyText else { return false }
      return true
    }

    public static func == (lhs: ProductResponse, rhs: ProductResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
