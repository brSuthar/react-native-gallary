//
//  SwiftCollectionView.swift
//  card_input
//
//  Created by Peshwa on 26/09/23.
//
import UIKit
import Foundation
import SwiftUI

class SwiftCollectionView: UIView {
  
  let deviceSize = UIScreen.main.bounds
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
      self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.deviceSize.width, height: self.deviceSize.height))
      self.backgroundColor = .black
      let siwftUIview = ImageCollecitonView()
      let iamgeConllection = UIHostingController(rootView: siwftUIview )
      iamgeConllection.view.frame = self.bounds
      self.addSubview(iamgeConllection.view)
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
  }
  
}
