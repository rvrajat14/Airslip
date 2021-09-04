//
//  APPError.swift
//  Airslip
//
//  Created by Graham Whitehouse on 06/08/2021.
//

import Foundation

enum ApiError: Error {
    case NetworkError(Error)
    case DataNotFound
    case JsonParsingError(Error)
    case InvalidStatusCode(Int)
    case ProcessIncomplete
}
