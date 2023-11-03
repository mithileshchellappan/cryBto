//
//  HomeStatsView.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 28/10/23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.stats){ stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment:showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Provider: PreviewProvider {
    static var previews: some View{
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
