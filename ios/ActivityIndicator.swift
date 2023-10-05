//
//  ActivityIndicator.swift
//  card_input
//
//  Created by Peshwa on 04/10/23.
//
import SwiftUI

struct ActivityIndicator: View {
  @Binding var isStopAnimation: Bool
  var body: some View {
    ZStack {
      Color.black
        .opacity(0.1)
        .ignoresSafeArea()
      ActivityIndicatorView(isStopAnimation: $isStopAnimation)
    }
  }
}

struct ActivityIndicatorView: UIViewRepresentable {
  @Binding var isStopAnimation: Bool
  var activity = UIActivityIndicatorView()
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    activity.frame = .zero
    activity.color = .white
    activity.startAnimating()
    activity.style = .large
    return activity
  }
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    if isStopAnimation {
      activity.stopAnimating()
    } else {
      activity.startAnimating()
    }
  }
  typealias UIViewType = UIActivityIndicatorView
}
