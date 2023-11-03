//
//  String.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 02/11/23.
//

import Foundation

extension String {
    var removeHTML: String {
       return self.replacingOccurrences(of: "<[^>]+>",with: "",options: .regularExpression)
    }
}
