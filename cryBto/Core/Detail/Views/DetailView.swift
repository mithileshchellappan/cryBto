//
//  DetailView.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 29/10/23.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    init(coin:Binding<Coin?>){
        self._coin = coin
        print("Initializing detail view for \(coin.wrappedValue?.name ?? "")")
    }
    
    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailViewLoading_Previews: PreviewProvider {
    static var previews: some View {
        DetailLoadingView(coin:.constant( dev.coin))
    }
}

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @State private var showFullDesc = false
    private let columns: [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    private let spacing: CGFloat = 30
    
    init(coin: Coin){
        _vm = StateObject(wrappedValue: DetailViewModel(coin))
        print("Initializing detail view for \(coin.name)")
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing:20){
                    overviewTitle
                    Divider()
                    
                    descriptionSection
                    
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                }
                .padding()
            }
            
        }
        
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                navigationBarTrailing
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    
    private var navigationBarTrailing: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .foregroundColor(Color.theme.accent)
            CoinImageView(vm.coin)
                .frame(width: 25,height: 25)
        }
    }
    
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalTitle: some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty  {
                VStack(alignment: .leading){
                    Text(coinDescription)
                    //                                    .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(showFullDesc ? .max : 3)
                        .onTapGesture {
                            withAnimation(.easeInOut){
                                showFullDesc.toggle()
                            }
                        }
                }
                .frame(maxWidth: .infinity , alignment:.leading)
            }
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns,alignment: .leading,spacing: spacing,pinnedViews: []) {
            ForEach(vm.overviewStatistics){
                stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns,alignment: .leading,spacing: spacing,pinnedViews: []) {
            ForEach(vm.additionalStatistics){
                stat in
                StatisticView(stat: stat)
            }
        }
    }
}

