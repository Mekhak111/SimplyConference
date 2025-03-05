//
//  WebView.swift
//  Simply
//
//  Created by Mekhak Ghapantsyan on 3/3/25.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  
  var url: URL = URL(string: "https://www.simplytechnologies.net/careers")!
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    let request = URLRequest(url:url)
    uiView.load(request)
  }
  
}
