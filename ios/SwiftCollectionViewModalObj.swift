//
//  SwiftCollectionViewModalObj.swift
//  card_input
//
//  Created by Peshwa on 27/09/23.
//

import Foundation
import SwiftUI
import UIKit
import AVKit
import Photos



// MARK: - Methods -

// requestImg methode use to genrate or create image from imageAssets

func requestImg(asset: PHAsset, complition: @escaping((Data) -> Void)){
  
  let manger = PHImageManager()
  manger.requestImageDataAndOrientation(for: asset, options: nil) { imgData, name, _, _ in
    if let imgData = imgData{
      complition(imgData)
    }
  }
  
}

// requestVideoUrl methode use to genrate or create video path from imageAssets
func requestVideoUrl(asset: PHAsset, complition: @escaping((String) -> Void)){
  let manger = PHImageManager()
  manger.requestAVAsset(forVideo: asset,options: nil) { avAsset, _, _ in
              guard let avAsset = avAsset as? AVURLAsset else {
                print("Failed to fetch AVAsset for the video.")
                return
              }
            complition(avAsset.url.absoluteString)
            }
}

struct CollectionView : UIViewRepresentable {
  
  @Binding var arrOfAssets: [AssetModal]
  @State var collectionView : UICollectionView?
  @Binding var endScrolling: Bool
  @Binding var selectedMediaContainer: [AssetModal]
  @Binding var isMultipaleSelected: Bool
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: .infinity))
    view.backgroundColor = .clear
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    DispatchQueue.main.async {
      self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
      self.collectionView?.backgroundColor = .black
      self.collectionView?.register(Cell.self, forCellWithReuseIdentifier: "Cell")
      self.collectionView?.delegate = context.coordinator
      self.collectionView?.dataSource = context.coordinator
      layout.itemSize = CGSize(width: (UIScreen.main.bounds.width) / 5, height: (UIScreen.main.bounds.width) / 5) // Set your desired cell size
//      layout.minimumInteritemSpacing = 8 // Set the spacing between items horizontally
      layout.minimumLineSpacing = 10
      view.addSubview(self.collectionView ?? UIView())
    }
    return view
  }
  
  // Update colletion Method
  
  func updateUIView(_ uiView: UIView, context: Context) {
    print(selectedMediaContainer)
    collectionView?.reloadData()
  }
  
  typealias UIViewType = UIView
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }
  
  //Colletion view class
  
  class Coordinator : NSObject , UICollectionViewDelegate , UICollectionViewDataSource , UIScrollViewDelegate {
    
    var parent: CollectionView
    init(_ parent: CollectionView) {
      self.parent = parent
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return parent.arrOfAssets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let object = parent.arrOfAssets[indexPath.item]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
      cell.backgroundColor = .orange
      cell.playBt.isHidden = !(object.mediaType == .video)
      cell.imageView.image = object.photo
      if parent.selectedMediaContainer.contains(where: { $0.id == object.id }) {
        if parent.isMultipaleSelected {
          cell.numberView.isHidden = false
          cell.countText.font = UIFont(name: "", size: 10)
          cell.countText.text = String(parent.selectedMediaContainer.first(where: { $0.id == object.id})?.selectedIndexNum ?? 1)
        } else
        {
          cell.numberView.isHidden = true
        }
        cell.selectedframe.isHidden = false
      } else {
        cell.selectedframe.isHidden = true
      }
      
      
      return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      var object = parent.arrOfAssets[indexPath.item]
      
      if parent.isMultipaleSelected {
             if parent.selectedMediaContainer.contains(where: { $0.id == object.id }) {
                 if let index = parent.selectedMediaContainer.firstIndex(where: { $0.id == object.id }) {
                     parent.selectedMediaContainer.remove(at: index)
                     
                     // Update the selectedIndexNum of the remaining selected items
                   for i in 0..<parent.selectedMediaContainer.count {
                                       parent.selectedMediaContainer[i].selectedIndexNum = i + 1
                                   }
                 }
             } else {
                 object.selectedIndexNum = parent.selectedMediaContainer.count + 1
                 parent.selectedMediaContainer.append(object)
             }
         } else {
             parent.selectedMediaContainer.removeAll()
             object.selectedIndexNum = 1
             parent.selectedMediaContainer.append(object)
         }
      
      parent.collectionView?.reloadData()
    }
    
    // This method use to find scroll position
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      // Calculate how close the user is to the bottom
      let offsetY = scrollView.contentOffset.y
      let contentHeight = scrollView.contentSize.height
      let scrollViewHeight = scrollView.frame.size.height
      let scrollPosition = offsetY + scrollViewHeight
      if scrollPosition >= contentHeight - 200 {
        parent.endScrolling = true
      }
    }
  }
}

// Collection View Cell

class Cell : UICollectionViewCell {

  var imageView = UIImageView()
  var selectedframe = UIImageView()
  var numberView = UIView()
  var countText = UILabel()
  var playBt = UIImageView()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    imageView.frame = self.bounds
    selectedframe.frame = self.bounds
    imageView.backgroundColor = .blue
   
    selectedframe.image = UIImage(named: "selectedFrame")
    numberView.frame = CGRect(x: imageView.frame.maxX - 14, y: imageView.frame.minY, width: 16  , height: 16)
    numberView.backgroundColor = UIColor(named: "orenge")
    numberView.layer.cornerRadius = 9
    countText.frame = numberView.bounds
   
    countText.textAlignment = .center
    countText.textColor = .white
    playBt.image = UIImage(named: "playBt")
    playBt.frame = CGRect(x: imageView.frame.midX - 15, y: imageView.frame.midY - 15, width: 30, height: 30)
   
    
    self.addSubview(imageView)
    self.addSubview(selectedframe)
    selectedframe.addSubview(numberView)
    numberView.addSubview(countText)
    self.addSubview(playBt)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// This media asset Modal

struct AssetModal: Hashable, Identifiable {
  var id = UUID().uuidString
  var asset: PHAsset
  var photo: UIImage
  var videoPath: String
  var assetsIndex: Int
  var mediaType: PHAssetMediaType {
    return asset.mediaType
  }
  var imageData: Data
  var selectedIndexNum: Int = 0
  var totoalAssets: Int = 0
}

