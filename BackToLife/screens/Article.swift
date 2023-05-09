//
//  Article.swift
//  BackToLife
//
//  Created by Mac mini 8 on 30/4/2023.
//

import SwiftUI
import WebKit

struct ArticleView: View {
    @State var articles = [Article]()
    
    var body: some View {
        NavigationView {
            
            List(articles, id: \.id) { article in
                if let link = article.link {
                    NavigationLink(destination: WebView(url: link)){
                        VStack(alignment: .leading)
                        {
                
     
                             
                            
                            Text(article.title)
                                .font(.headline)
                                .foregroundColor(Color("DarkPink"))
                            Spacer()
                            
                            Text(article.content!)
                                .font(.subheadline)
                            Spacer()
                            Text(article.pubDate)
                                .font(.caption)
                                .foregroundColor(Color("DarkPink"))
                            
                        }
                        .padding(.vertical, 20)

                    }}}
        }
        .navigationTitle("Articles")
        .navigationBarBackButtonHidden(true)
     
        .onAppear {
            fetchArticles()
        }
    }
    
    func fetchArticles() {
        let url = URL(string: "http://localhost:7001/rss?page=1")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
                      guard let data = data else { return }

                      do {
                          let result = try JSONDecoder().decode(RssParserResponse.self, from: data)
                          self.articles = result.articles
                      } catch let error {
                          print(error.localizedDescription)
                      }
                  }
                  .resume()
    }
}

struct Article: Codable, Identifiable {
    let id: Int
      let title: String
      let link: String
      let pubDate: String
      let content: String?
      let tags: [String]?
}

struct RssParserResponse: Decodable {
    let page: Int
    let pageSize: Int
    let total: Int
    let pages: Int
    let articles: [Article]
}
struct WebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encodedUrl) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
