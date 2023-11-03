//
//  CoinImageService.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 28/10/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image:UIImage? = nil
    
    private var imageSub: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    
    init(_ coin: Coin){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: coin.id, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        
        print("downloading image")
        guard let url = URL(string:coin.image) else {
            print("error setting URL")
            return}
        imageSub = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedImage) in
                guard let self = self,
                      let  downloadedImage = returnedImage
                else {return}
                self.image = downloadedImage
                self.imageSub?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.coin.id, folderName: self.folderName)
            })
    }
}
