//
//  JSONDecoder.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 28/10/23.
//

import Foundation

extension JSONDecoder {
    static let snakeCaseConverting: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
