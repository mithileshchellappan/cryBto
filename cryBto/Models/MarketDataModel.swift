//
//  MarketDataModel.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 28/10/23.
//
///JSON DATA
/*URL: https://api.coingecko.com/api/v3/global
 
    JSON: {"data":{"active_cryptocurrencies":10608,"upcoming_icos":0,"ongoing_icos":49,"ended_icos":3376,"markets":905,"total_market_cap":{"btc":38165860.22126202,"eth":728240541.2443274,"ltc":19122001440.690666,"bch":5321237114.400864,"bnb":5756092357.493901,"eos":2087888461340.845,"xrp":2384829599292.676,"xlm":11493187722946.234,"link":116844271733.20566,"dot":311742795238.94135,"yfi":228684454.48429736,"usd":1303108091501.9915,"aed":4786316020086.804,"ars":456133440808898.5,"aud":2056997821894.8186,"bdt":143348661014862.34,"bhd":491201382659.30884,"bmd":1303108091501.9915,"brl":6533833488898.472,"cad":1808909497218.4858,"chf":1175353980427.3164,"clp":1214078691173018.2,"cny":9534581283901.777,"czk":30387829139780.68,"dkk":9206458666461.541,"eur":1232805409965.4575,"gbp":1074462139550.8661,"hkd":10191412917423.336,"huf":473236734509864.6,"idr":2.0733361911460704e+16,"ils":5284155435364.222,"inr":108700781270180.38,"jpy":195038835097662.5,"krw":1767301255856828.2,"kwd":402907990811.5017,"lkr":426846683275897.56,"mmk":2730494955619833.5,"mxn":23605934691475.793,"myr":6226902015242.247,"ngn":1026523186674073.9,"nok":14549201841619.715,"nzd":2242100416968.4014,"php":74264134044022.86,"pkr":360809253048659.9,"pln":5505214692006.613,"rub":122752769188406.38,"sar":4885674102739.575,"sek":14630932781118.738,"sgd":1783492373893.7412,"thb":47014802952489.9,"try":36668550822310.03,"twd":42323649007001.35,"uah":47490739726965.23,"vef":130480213202.09444,"vnd":3.2029206553304756e+16,"zar":24548862403378.547,"xdr":991418970203.7219,"xag":56371361427.579315,"xau":649364824.1572707,"bits":38165860221262.02,"sats":3816586022126202.5},"total_volume":{"btc":4033565.6341138757,"eth":76964229.37940732,"ltc":2020912077.4297972,"bch":562375878.1064067,"bnb":608333630.7729418,"eos":220658858380.34055,"xrp":252041134646.44504,"xlm":1214659561108.7346,"link":12348707359.7666,"dot":32946592013.61015,"yfi":24168556.697434746,"usd":137719207295.37137,"aed":505842648395.8979,"ars":48206542725635.195,"aud":217394175730.37683,"bdt":15149828391491.94,"bhd":51912704313.160965,"bmd":137719207295.37137,"brl":690529338708.8702,"cad":191174917607.0694,"chf":124217491650.54745,"clp":128310119500393.38,"cny":1007663895938.7738,"czk":3211543054524.4116,"dkk":972986199541.7957,"eur":130289256061.78592,"gbp":113554719744.91061,"hkd":1077081262376.0037,"huf":50014107321387.21,"idr":2191208991514461.8,"ils":558456894351.0212,"inr":11488061141314.703,"jpy":20612713509055.58,"krw":186777543318128.28,"kwd":42581401703.65597,"lkr":45111366617068.72,"mmk":288572838480758.5,"mxn":2494797349795.5864,"myr":658091232060.93,"ngn":108488283098697.89,"nok":1537634949452.8193,"nzd":236956775969.0624,"php":7848618036920.846,"pkr":38132189216492.6,"pln":581819580676.6074,"rub":12973147950031.877,"sar":516343324794.55005,"sek":1546272698134.387,"sgd":188488704468.77332,"thb":4968767699310.307,"try":3875322227565.845,"twd":4472982271465.582,"uah":5019067160829.195,"vef":13789824226.485538,"vnd":3385012314470847.5,"zar":2594450830475.31,"xdr":104778287821.59882,"xag":5957617223.46364,"xau":68628235.37942928,"bits":4033565634113.8755,"sats":403356563411387.56},"market_cap_percentage":{"btc":51.162329073148605,"eth":16.51500210978986,"usdt":6.494549427907346,"bnb":2.672225566381191,"xrp":2.245363470815408,"usdc":1.9185231430319742,"steth":1.2049769991341637,"sol":1.0273524429660432,"ada":0.7843685162195349,"doge":0.7498320504451294},"market_cap_change_percentage_24h_usd":0.6646076929594366,"updated_at":1698506851}}
 
 */
import Foundation

struct GlobalData: Codable {
    let data: MarketData?
}

struct MarketData: Codable {
//    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int?
//    let markets: Int?
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
//    let updatedAt: Int?
    
    var marketCap: String {
//        if let item = totalMarketCap.first(where: { (key,value) -> Bool in
//            return key == "usd"
//        }){
//            return "\(item.value)"
//        }
        
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        
        return ""
    }
    
    var volume: String{
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var bitcoinDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return "\(item.value.asPercentString())"
        }
        return ""
    }
}