//
//  DetailViewModel.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 30/10/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil


    
    @Published var coin: Coin
    
    init(_ coin: Coin){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map({ (coinDetail,coin) -> (overview: [Statistic], additional: [Statistic]) in
                
                ///Overview Array
                let priceStat = Statistic(title: "Current Price", value: coin.currentPrice.asCurrencyWithNDecimals(), percentageChange: coin.priceChangePercentage24H)
                let marketCapStat = Statistic(title: "Market Cap", value: "$" + (coin.marketCap?.formattedWithAbbreviations() ?? ""), percentageChange: coin.marketCapChangePercentage24H)
                let rankStat = Statistic(title: "Rank", value: "\(coin.rank)")
                let volumeStat = Statistic(title: "Volume", value: "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? ""))
                
                let overviewArray: [Statistic] = [priceStat,marketCapStat,rankStat,volumeStat]
                
                ///Additional
                let highStat = Statistic(title: "24H High", value: coin.high24H?.asCurrencyWithNDecimals() ?? "n/a")
                let lowStat = Statistic(title: "24H Low", value: coin.low24H?.asCurrencyWithNDecimals() ?? "n/a")
                let priceChangeStat = Statistic(title: "Price Change 24H", value: coin.priceChange24H?.asCurrencyWithNDecimals() ?? "n/a", percentageChange: coin.priceChangePercentage24H)
                let marketCapPercentStat = Statistic(title: "Market Cap Change 24H", value: "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? ""),percentageChange: coin.marketCapChangePercentage24H)
                
                let blockTime: String = coinDetail?.blockTimeInMinutes == 0 ? "n/a" : "\(String(describing: coinDetail?.blockTimeInMinutes ?? 0))"
                let blockStat = Statistic(title: "Block Time", value: blockTime)
                
                let hashingStat = Statistic(title: "Hashing Algorithm", value: coinDetail?.hashingAlgorithm ?? "n/a")
                
                let additionalArray: [Statistic] = [highStat,lowStat,priceChangeStat,marketCapPercentStat,blockStat,hashingStat]
                
                return (overviewArray,additionalArray)
            })
            .sink { [weak self] (returnedArrays) in
                print("Received Coin Detail")
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetail
            .sink {[weak self] returnedCoinDetail in
                self?.coinDescription = returnedCoinDetail?.readableDescription
                self?.websiteURL = returnedCoinDetail?.links?.homepage?.first
                self?.redditURL = returnedCoinDetail?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
}
