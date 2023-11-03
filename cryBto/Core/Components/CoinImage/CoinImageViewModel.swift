//
//  CoinImageViewModel.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 28/10/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading = false
    
    private var coin: Coin
    private var cancellable = Set<AnyCancellable>()
    private let dataService: CoinImageService
    
    
    init(_ coin: Coin){
        self.coin = coin
        self.dataService = CoinImageService(self.coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellable)

    }
    
}
