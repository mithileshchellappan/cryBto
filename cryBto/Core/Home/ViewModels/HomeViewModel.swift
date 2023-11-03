//
//  HomeViewModel.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 27/10/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var stats: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank ,rankReversed,holdings,holdingsReversed,price,priceReversed
    }
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers() {
        //        dataService.$allCoins
        //            .sink { [weak self] returnedCoins in
        //                self?.allCoins = returnedCoins
        //            }
        //            .store(in: &cancellables)
        
        
        
        ///Combine all coins and filter through search text.
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler:  DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (coins) in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        /// The filtered / unfiltered (if no search text) coins are passed into portfolioEntities to find the coins in our portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(filterAllPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
                
            }
            .store(in: &cancellables)
        
        /// Market Data for the top view is mapped here. Also added portfolioCoins to find portfolio value
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(filterMarketData)
            .sink {[weak self] receivedValues in
                self?.stats = receivedValues
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortfolio(coin: Coin,amount:Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAllPortfolioCoins(coinModels: [Coin],portfolioEntites: [PortfolioEntity]) -> [Coin] {
        coinModels.compactMap { (coin) -> Coin? in
            guard let entity = portfolioEntites.first(where: {$0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func filterAndSortCoins(text:String, startingCoins: [Coin], sortOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, startingCoins: startingCoins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    private func filterCoins(text:String, startingCoins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return startingCoins
        }
        
        let lowerText = text.lowercased()
        return startingCoins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerText) || coin.symbol.lowercased().contains(lowerText) || coin.id.lowercased().contains(lowerText)
        }
    }
    
    private func sortCoins(sort: SortOption,coins: inout [Coin]) {
        switch sort {
        case .rank,.holdings:
            coins.sort(by: {$0.rank < $1.rank})
//            return coins.sorted { coin1, coin2 in
//                return coin1.rank < coin2.rank
//            }
        case .rankReversed,.holdingsReversed:
            coins.sort(by: {$0.rank > $1.rank})
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        ///Will only sort by holdings and reverse holdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func filterMarketData (marketData: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = marketData else {
            return stats
        }
        
        //        let portfolioValue = portfolioCoins.map { (coin) -> Double in
        //            return coin.currentHoldingsValue
        //        }
        //The top and bottom are same functionality
        let portfolioValue = portfolioCoins.map({$0.currentHoldingsValue}).reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title:"Portfolio Value",value:"\(portfolioValue.asCurrencyWithNDecimals(min:2,max:2))",percentageChange: percentageChange)
        stats.append(contentsOf: [
            Statistic(title:"Market Cap",value:data.marketCap,percentageChange: data.marketCapChangePercentage24HUsd),
            Statistic(title: "24h Volume", value: data.volume),
            Statistic(title: "BTC Dominance", value: data.bitcoinDominance),
            portfolio
        ])
        
        return stats
    }
    
}
