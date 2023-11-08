//
//  Error.swift
//
//
//  Created by Alfian Losari on 08/11/23.
//

import Foundation

extension String: LocalizedError {
    
    public var errorDescription: String? { self }
}
