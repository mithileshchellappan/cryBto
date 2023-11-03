//
//  DismissButton.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 29/10/23.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
