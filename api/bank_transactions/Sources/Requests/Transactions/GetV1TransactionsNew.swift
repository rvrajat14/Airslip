//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension BankTransactionsApi.Transactions {

    public enum GetV1TransactionsNew {

        public static let service = APIService<Response>(id: "getV1TransactionsNew", tag: "Transactions", method: "GET", path: "/v1/transactions/new", hasBody: false, securityRequirements: [])

        public final class Request: APIRequest<Response> {

            public init() {
                super.init(service: GetV1TransactionsNew.service)
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = AllNewTransactionsResponse

            /** Success */
            case status200(AllNewTransactionsResponse)

            /** Bad Request */
            case status400(ErrorResponse)

            /** Unauthorized */
            case status401(YapilyUnauthorisedResponse)

            public var success: AllNewTransactionsResponse? {
                switch self {
                case .status200(let response): return response
                default: return nil
                }
            }

            public var response: Any {
                switch self {
                case .status200(let response): return response
                case .status400(let response): return response
                case .status401(let response): return response
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                case .status400: return 400
                case .status401: return 401
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                case .status400: return false
                case .status401: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode(AllNewTransactionsResponse.self, from: data))
                case 400: self = try .status400(decoder.decode(ErrorResponse.self, from: data))
                case 401: self = try .status401(decoder.decode(YapilyUnauthorisedResponse.self, from: data))
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