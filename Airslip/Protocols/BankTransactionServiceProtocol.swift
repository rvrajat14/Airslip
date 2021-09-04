//
//  WebServcieProtocol.swift
//  Airslip
//
//  Created by Graham Whitehouse on 03/08/2021.
//

import Foundation
import BankTransactionsApi

protocol BankTransactionServiceProtocol {
    func getTransactions(loadingDialogue: Bool, offset: Int?, sort: String?, completion: @escaping (Result<AllTransactionResponsePagedResult>) -> Void)
}
