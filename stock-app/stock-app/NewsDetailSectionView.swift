//
//  NewsDetailSectionView.swift
//  stock-app
//
//  Created by Varun Mehta on 17/04/24.
//

//import SwiftUI
//
//struct NewsDetailSectionView: View {
//    let newsData: [NewsItem] // Use NewsData instead of NewsItem
//    
//    @State private var selectedNewsItem: NewsItem?
//    @State private var isSheetPresented = false
//    
//    var body: some View {
//        VStack {
//            ForEach(newsData, id: \.id) { newsItem in
//                Button(action: {
//                    self.selectedNewsItem = newsItem
//                    self.isSheetPresented = true
//                }) {
//                    NewsItemRow(newsItem: newsItem)
//                }
//            }
//        }
//        .sheet(isPresented: $isSheetPresented) {
//            if let newsItem = selectedNewsItem {
//                NewsDetailSheet(newsItem: newsItem)
//            }
//        }
//    }
//}
//
//struct NewsDetailSheet: View {
//    let newsItem: NewsItem
//    
//    var body: some View {
//        VStack {
//            Text(newsItem.headline)
//            Text(newsItem.summary)
//            Text(newsItem.source)
//            Text(formatDate(newsItem.datetime))
//            
//            Button(action: {
//                shareToTwitter(newsItem: newsItem)
//            }) {
//                Text("Share on Twitter")
//            }
//            
//            Button(action: {
//                shareToFacebook(newsItem: newsItem)
//            }) {
//                Text("Share on Facebook")
//            }
//        }
//        .padding()
//    }
//    
//    func shareToTwitter(newsItem: NewsItem) {
//        let twitterURL = "https://twitter.com/intent/tweet?text=\(newsItem.headline)&url=\(newsItem.url)"
//        if let url = URL(string: twitterURL), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//   func formatDate(_ timestamp: TimeInterval) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        let date = Date(timeIntervalSince1970: timestamp)
//        return dateFormatter.string(from: date)
//    }
//
//    
//    func shareToFacebook(newsItem: NewsItem) {
//        let facebookURL = "https://www.facebook.com/sharer/sharer.php?u=\(newsItem.url)"
//        if let url = URL(string: facebookURL), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
//}
//
//struct NewsItemRow: View {
//    let newsItem: NewsItem
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(newsItem.headline)
//            Text(newsItem.source)
//                .font(.caption)
//        }
//        .padding()
//    }
//}

import SwiftUI
import Kingfisher

struct NewsDetailSectionView: View {
    let newsData: [NewsItem]
    @State private var selectedNewsItem: NewsItem?
    
    // Computed property to filter newsData based on whether image and summary exist and are not empty
   
    var topNewsData: [NewsItem] {
            var filteredNewsData: [NewsItem] = []
            var count = 0
            for newsItem in newsData {
                // Check if newsItem contains image and summary properties and they are not nil or empty
                if let image = newsItem.image, !image.isEmpty,
                               !newsItem.summary.isEmpty {
                                filteredNewsData.append(newsItem)
                                count += 1
                            }
                // Stop if we have found 20 news items
                if count == 20 {
                    break
                }
            }
            return filteredNewsData
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("News")
                .font(.title)
                .padding(.bottom, 5)
            ForEach(topNewsData, id: \.id) { newsItem in
                if newsItem == topNewsData.first {
                    Button(action: {
                        self.selectedNewsItem = newsItem}){
                            FirstNewsItemRow(newsItem: newsItem)}.buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        self.selectedNewsItem = newsItem}){
                            NewsItemRow(newsItem: newsItem)}.buttonStyle(PlainButtonStyle())
                }
                Divider() // Add a divider between news items
            }
        }
        .sheet(item: $selectedNewsItem) { newsItem in
            NewsDetailSheet(newsItem: newsItem)
        }
    }
}


struct NewsDetailSheet: View {
    let newsItem: NewsItem
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Text(newsItem.source)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(formatDate(newsItem.datetime))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Divider()
                
                Text(newsItem.headline)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(newsItem.summary)
                    .font(.body)
                HStack{
                    Text("For more details, click ").foregroundColor(.gray)
                        .font(.body)
                    Link("here", destination: URL(string: newsItem.url)!)
                }
                
                
                HStack(spacing: 20) {
                    Button(action: {
                        shareToTwitter(newsItem: newsItem)
                    }) {
                        Image("sl_z_072523_61700_05")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
//                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        shareToFacebook(newsItem: newsItem)
                    }) {
                        Image("f_logo_RGB-Blue_144")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
//                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    
    func formatDate(_ timestamp: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
    
    func shareToTwitter(newsItem: NewsItem) {
        let twitterURL = "https://twitter.com/intent/tweet?text=\(newsItem.headline)&url=\(newsItem.url)"
        if let url = URL(string: twitterURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func shareToFacebook(newsItem: NewsItem) {
        let facebookURL = "https://www.facebook.com/sharer/sharer.php?u=\(newsItem.url)"
        if let url = URL(string: facebookURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}



struct FirstNewsItemRow: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            KFImage(URL(string: newsItem.image ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 240)
                .frame(width: 365)
                .cornerRadius(20)
                .clipped()
            
            VStack(alignment: .leading) {
                HStack{
                    Text(newsItem.source)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(publishedAgo(from: newsItem.datetime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
            }
            
            Text(newsItem.headline)
                .font(.headline).lineLimit(3)
        }
//        .padding()
    }
    
    func publishedAgo(from timestamp: TimeInterval) -> String {
        let currentDate = Date()
        let articleDate = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: articleDate, to: currentDate)
        
        if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
}

struct NewsItemRow: View {
    let newsItem: NewsItem
    
    var body: some View {
        HStack(spacing: 2) {
            VStack(alignment: .leading, spacing: 2) {
                HStack{
                    Text(newsItem.source)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(publishedAgo(from: newsItem.datetime))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
               
                Text(newsItem.headline)
                    .font(.headline).lineLimit(3)
            }
            Spacer()
            KFImage(URL(string: newsItem.image ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(20)
                .clipped()
        }
//        .padding()
    }
    
    func publishedAgo(from timestamp: TimeInterval) -> String {
        let currentDate = Date()
        let articleDate = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: articleDate, to: currentDate)
        
        if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
}





    // Format date
    


