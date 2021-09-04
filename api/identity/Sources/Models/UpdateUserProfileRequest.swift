//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class UpdateUserProfileRequest: APIModel {

    public var city: String?

    public var country: String?

    public var county: String?

    public var dateOfBirth: DateTime?

    public var firstLineAddress: String?

    public var firstName: String?

    public var gender: String?

    public var postalcode: String?

    public var secondLineAddress: String?

    public var surname: String?

    public init(city: String? = nil, country: String? = nil, county: String? = nil, dateOfBirth: DateTime? = nil, firstLineAddress: String? = nil, firstName: String? = nil, gender: String? = nil, postalcode: String? = nil, secondLineAddress: String? = nil, surname: String? = nil) {
        self.city = city
        self.country = country
        self.county = county
        self.dateOfBirth = dateOfBirth
        self.firstLineAddress = firstLineAddress
        self.firstName = firstName
        self.gender = gender
        self.postalcode = postalcode
        self.secondLineAddress = secondLineAddress
        self.surname = surname
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        city = try container.decodeIfPresent("city")
        country = try container.decodeIfPresent("country")
        county = try container.decodeIfPresent("county")
        dateOfBirth = try container.decodeIfPresent("dateOfBirth")
        firstLineAddress = try container.decodeIfPresent("firstLineAddress")
        firstName = try container.decodeIfPresent("firstName")
        gender = try container.decodeIfPresent("gender")
        postalcode = try container.decodeIfPresent("postalcode")
        secondLineAddress = try container.decodeIfPresent("secondLineAddress")
        surname = try container.decodeIfPresent("surname")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(city, forKey: "city")
        try container.encodeIfPresent(country, forKey: "country")
        try container.encodeIfPresent(county, forKey: "county")
        try container.encodeIfPresent(dateOfBirth, forKey: "dateOfBirth")
        try container.encodeIfPresent(firstLineAddress, forKey: "firstLineAddress")
        try container.encodeIfPresent(firstName, forKey: "firstName")
        try container.encodeIfPresent(gender, forKey: "gender")
        try container.encodeIfPresent(postalcode, forKey: "postalcode")
        try container.encodeIfPresent(secondLineAddress, forKey: "secondLineAddress")
        try container.encodeIfPresent(surname, forKey: "surname")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? UpdateUserProfileRequest else { return false }
      guard self.city == object.city else { return false }
      guard self.country == object.country else { return false }
      guard self.county == object.county else { return false }
      guard self.dateOfBirth == object.dateOfBirth else { return false }
      guard self.firstLineAddress == object.firstLineAddress else { return false }
      guard self.firstName == object.firstName else { return false }
      guard self.gender == object.gender else { return false }
      guard self.postalcode == object.postalcode else { return false }
      guard self.secondLineAddress == object.secondLineAddress else { return false }
      guard self.surname == object.surname else { return false }
      return true
    }

    public static func == (lhs: UpdateUserProfileRequest, rhs: UpdateUserProfileRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
