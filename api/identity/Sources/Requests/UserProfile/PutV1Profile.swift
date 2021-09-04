//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension IdentityApi.UserProfile {

    public enum PutV1Profile {

        public static let service = APIService<Response>(id: "putV1Profile", tag: "UserProfile", method: "PUT", path: "/v1/profile", hasBody: true, securityRequirements: [])

        public final class Request: APIRequest<Response> {

            public var body: UpdateUserProfileRequest?

            public init(body: UpdateUserProfileRequest?, encoder: RequestEncoder? = nil) {
                self.body = body
                super.init(service: PutV1Profile.service) { defaultEncoder in
                    return try (encoder ?? defaultEncoder).encode(body)
                }
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Void

            /** Success */
            case status204

            /** Bad Request */
            case status400(ErrorResponse)

            public var success: Void? {
                switch self {
                case .status204: return ()
                default: return nil
                }
            }

            public var failure: ErrorResponse? {
                switch self {
                case .status400(let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<Void, ErrorResponse> {
                if let successValue = success {
                    return .success(successValue)
                } else if let failureValue = failure {
                    return .failure(failureValue)
                } else {
                    fatalError("Response does not have success or failure response")
                }
            }

            public var response: Any {
                switch self {
                case .status400(let response): return response
                default: return ()
                }
            }

            public var statusCode: Int {
                switch self {
                case .status204: return 204
                case .status400: return 400
                }
            }

            public var successful: Bool {
                switch self {
                case .status204: return true
                case .status400: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 204: self = .status204
                case 400: self = try .status400(decoder.decode(ErrorResponse.self, from: data))
                default: throw APIClientError.unexpectedStatusCode(statusCode: statusCode, data: data)
                }
            }

            public var description: String {
                return "\(statusCode) \(successful ? "success" : "failure")"
            }

            public var debugDescription: String {
                var string = description
                let responseString = "\(response)"
                if responseString != "()" {
                    string += "\n\(responseString)"
                }
                return string
            }
        }
    }
}
