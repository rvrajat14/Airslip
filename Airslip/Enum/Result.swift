//
//  Result.swift
//  Airslip
//
//  Created by Graham Whitehouse on 06/08/2021.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Failure(ApiError)
}
