////
////  FetchAssets.swift
////  card_input
////
////  Created by Peshwa on 27/09/23.
////
//
import Foundation
import Photos
import UIKit
import AVKit
//
//



class AssetsManager : ObservableObject {
  @Published var selectedMediaContainer: [AssetModal] = []
  @Published var isMultipaleSelected: Bool = false
  @Published var arrOfImages: [AssetModal] = []
  
  
  // Load Assets
  
  func loadAssets(endIndex: Int,startIndex: Int = 0 ,complationBlock: @escaping(([AssetModal]) -> Void)){
    var arrOfAssets: [AssetModal] = []
    let fetchOptions = PHFetchOptions()
    let mediaTypes: [PHAssetMediaType] = [.image, .video]
    fetchOptions.predicate = NSPredicate(format: "mediaType IN %@", mediaTypes.map { $0.rawValue })
    let assets = PHAsset.fetchAssets(with: fetchOptions)
    assets.enumerateObjects({ (asset, currentIndex, stop) in
      if currentIndex >= startIndex && currentIndex <= endIndex {
        print(currentIndex)
        arrOfAssets.append(AssetModal(asset: asset, photo: UIImage() , videoPath: "",assetsIndex: currentIndex,imageData: Data(),totoalAssets: assets.count ))
      }
    })
    complationBlock(arrOfAssets)
  }
  
  //Load Images
  
  func loadImages(assets: [AssetModal],complationBlock: @escaping(() -> Void)) {
    let manager = PHImageManager.default()
    for asset in arrOfImages {
      manager.requestImage(for: asset.asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: nil) { image , _ in
        if let index = self.arrOfImages.firstIndex(where: { $0.id == asset.id }) {
          if let fetchImage = image {
            self.arrOfImages[index].photo = fetchImage
          }
        }
        if self.arrOfImages.last?.id == asset.id{
          complationBlock()
        }
      }
    }
  }
  
}
