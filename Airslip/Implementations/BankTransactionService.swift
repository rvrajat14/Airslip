//
//  WebService.swift
//  Airslip
//
//  Created by Graham Whitehouse on 03/08/2021.
//

import Foundation
import Resolver
import BankTransactionsApi

class BankTransactionService : BankTransactionServiceProtocol {

    @Injected var dialogueService: DialogueServiceProtocol
    @Injected var urlService: UrlServiceProtocol
    @Injected var userService: UserServiceProtocol
    @Injected var authenticationService: AuthenticationServiceProtocol
    
    func getTransactions(loadingDialogue: Bool, offset: Int? = 0, sort: String? = "", completion: @escaping (Result<AllTransactionResponsePagedResult>) -> Void) {
        authenticationService.refresh()

        if loadingDialogue {
            self.dialogueService.showProgress()
        }
       
        let getTransactionsRequest = BankTransactionsApi.Transactions.GetV1Transactions
            .Request(offset: offset, limit: 50, sort: sort, merchantName: "")
        
        let baseUrl = urlService.baseUrlFor(apiType: BaseApiType.BankTransactions)
        let apiClient = APIClient.init(baseURL: baseUrl)
        apiClient.defaultHeaders.add(["Authorization": "Bearer \(userService.bearerToken)"])
        apiClient.makeRequest(getTransactionsRequest) { apiResponse in

            guard (200...299).contains(apiResponse.urlResponse!.statusCode) else {
                completion(Result.Failure(ApiError.InvalidStatusCode(apiResponse.urlResponse!.statusCode)))
                return
            }
            
            switch apiResponse.result {
                case .success(let apiResponseValue):
                    completion(Result.Success((apiResponseValue.success?.pagedData)!))
                
                case .failure(let apiError):
                    completion(Result.Failure(ApiError.NetworkError(apiError)))

            }
        }
    }
}
