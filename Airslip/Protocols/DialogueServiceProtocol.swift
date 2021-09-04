//
//  AlertDialogueProtocol.swift
//  Airslip
//
//  Created by Graham Whitehouse on 03/08/2021.
//

import Foundation

protocol DialogueServiceProtocol {
    

    mutating func showProgress()
    mutating func hideProgress()
    
    mutating func displayNoConnection()

    
}
