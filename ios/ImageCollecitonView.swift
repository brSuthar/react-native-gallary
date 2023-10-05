//
//  ImageCollecitonView.swift
//  card_input
//
//  Created by Peshwa on 26/09/23.
//

import SwiftUI
import AVKit
//import URLImage

struct ImageCollecitonView: View {
  @State private var totalCount: Int = 0
    @State private var contentOffset: CGPoint = .zero
    @State private var endScrolling: Bool = false
  @ObservedObject var modalObject = AssetsManager()
//  @State var selectedUrlForVideo = String()
  @State private var player: AVPlayer?
  @State var currentPagee: Int = 0
  var imageModal:[CollectionModal] = []
  private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible())]
  @State var isStopAnmimation: Bool = false
  let deviceSize = UIScreen.main.bounds
  var body: some View {
    GeometryReader { geo in
      ZStack {
        Color.black .edgesIgnoringSafeArea(.all)
        VStack{
          TopHeader
          
          ImageViewContainer(selectedMediaContainer: $modalObject.selectedMediaContainer,
                             isMultipaleSelected: $modalObject.isMultipaleSelected)
          .frame(width: geo.size.width, height: geo.size.height / 2.5, alignment: .center)
          ZStack{
            CollectionView(arrOfAssets: $modalObject.arrOfImages,endScrolling: $endScrolling, selectedMediaContainer: $modalObject.selectedMediaContainer,isMultipaleSelected: $modalObject.isMultipaleSelected)
              .padding(20)
              .onAppear {
                loadData()
              }
              .onChange(of: endScrolling) { newValue in
                if modalObject.arrOfImages.first?.totoalAssets != modalObject.arrOfImages.count {
                  loadData()
                }
                
              }
            if isStopAnmimation == false{
              ActivityIndicator(isStopAnimation: $isStopAnmimation)
            }
          }
          .frame(width: geo.size.width, height: geo.size.height / 2, alignment: .center)
        }
        .frame(width: geo.size.width, height: geo.size.height )
      }
    }
  }
  
  var TopHeader : some View {
    HStack{
      Button {
      } label: {
        Image("backArrow").resizable().frame(width: 24, height: 24, alignment: .center)
          .background(
            Circle()
              .fill(Color("lightGrey"))
              .frame(width: 50, height: 50, alignment: .center)
            
          )
      }
      Text("Recent").foregroundColor(.white)
        .padding(.leading, 15)
        .font(.custom("", size: 24))
      
      Spacer()
      
      Button {
      } label: {
        VStack(spacing: -8){
          Text("Next")
            .foregroundColor(Color("orenge"))
            .font(.custom("", size: 18))
          Text("-----")
            .foregroundColor(Color("orenge"))
        }
        .padding(.top)
      }
    }.frame(height: 50, alignment: .center)
      .padding(.horizontal , 24)
      .padding(.top, 26)
  }
  
  func loadData() {
    isStopAnmimation = false
      DispatchQueue.global().async {
        totalCount = modalObject.arrOfImages.count + 100
        print("-------------------->",totalCount)
        modalObject.loadAssets(endIndex: totalCount , startIndex: modalObject.arrOfImages.count){ assets in
          DispatchQueue.main.async {
            if modalObject.arrOfImages.count == 0{
              if let assest = assets.first{
                modalObject.selectedMediaContainer.append(assest)
                modalObject.selectedMediaContainer[0].selectedIndexNum = 1
              }
              
            }
            modalObject.arrOfImages.append(contentsOf: assets)
            modalObject.loadImages(assets: assets) {
              print("Data load successfully .....")
              isStopAnmimation = true
            
            }
            self.endScrolling = false
          }
        }
      }
    }
}

struct ImageViewContainer: View {
  let deviceSize = UIScreen.main.bounds
  @Binding var selectedMediaContainer: [AssetModal]
  @State var player: AVPlayer?
  @State var loadedImgData: Data = Data()
  @State var videoPath: String = ""
  @Binding var isMultipaleSelected: Bool
  var body: some View {
    VStack{

      if let container  = selectedMediaContainer.last, container.mediaType == .image
      {
        Image(uiImage: UIImage(data: loadedImgData) ?? UIImage() )
            .resizable()
            .frame(width: deviceSize.width, height: deviceSize.width/1.5)
        
      }
      else {
        if let urlStr = URL(string: videoPath) {
          VideoPlayer(player: player)
//            .disabled(true)
            .onAppear() {
              player = AVPlayer(url: urlStr)
             
              player?.play()
            
            }
            .onChange(of: videoPath, perform: { newValue in
              if let newURLStr = URL(string: newValue) {
                              player = AVPlayer(url: newURLStr)
                              player?.play()
                          }
            })
            .frame(width: deviceSize.width, height: (deviceSize.height - 80) / 3)
        }
      }

      HStack(spacing: 10){
        Spacer()
        Button {
          isMultipaleSelected = !isMultipaleSelected
          if isMultipaleSelected {
            while(selectedMediaContainer.count < 1){
                selectedMediaContainer.removeFirst()
            }
          }
        } label: {
          isMultipaleSelected == true ? Image("multiSelected_ic").resizable().frame(width: 26, height: 26,alignment: .center) : Image("select").resizable().frame(width: 26, height: 26,alignment: .center)

        }

        Button {

        } label: {
          Image("camera").resizable().frame(width: 26, height: 26,alignment: .center)

        }
      }.padding(.trailing, 24)
        .onChange(of: selectedMediaContainer, perform: { newValue in
          if let asset = selectedMediaContainer.last?.asset{
            if selectedMediaContainer.last?.mediaType == .video{
              requestVideoUrl(asset: asset){ path in
                print("video path ==>", path)
                videoPath = path
              }
              
            }
            else{
              requestImg(asset: asset){ imgData in
                loadedImgData = imgData
            }
            
            }
          }
        })
        .onAppear {
          if let asset = selectedMediaContainer.last?.asset{
            if selectedMediaContainer.last?.mediaType == .video{
              requestVideoUrl(asset: asset){ path in
                videoPath = path
              }
              
            }
            else{
              requestImg(asset: asset){ imgData in
                loadedImgData = imgData
            }
            
            }
          }
         
        }
    }.onAppear {
      
    }
  }
}


struct ImageCollecitonView_Previews: PreviewProvider {
  static var previews: some View {
    ImageCollecitonView()
  }
}


// MARK: - Modal  -

struct CollectionModal: Identifiable , Codable {
  var id = UUID().uuidString
  var imgUrl: String = "https://picsum.photos/200/300"
  var mediaType: String = ""
  var isSelected: Bool = false
}

struct VideoPlayerViewController: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let viewController = AVPlayerViewController()
        viewController.player = player
        viewController.showsPlaybackControls = false // Hide playback controls
        return viewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the view controller if needed
    }
}

