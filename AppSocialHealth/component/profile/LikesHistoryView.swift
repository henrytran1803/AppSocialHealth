//
//  LikesHistoryView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 31/7/24.
//

import SwiftUI

struct LikesHistoryView: View {
    @ObservedObject var likemodel = LikeModelView()
    @State var isLoading = true
    @Binding var isOpen: Bool
    
    var body: some View {
        GeometryReader { geometry in
            if isLoading {
                AnimatedPlaceHolder()
            } else {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { isOpen = false }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Lịch sử yêu thích")
                        .font(.headline)
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(likemodel.likes) { like in
                                LikeRow(like: like)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                } .background(Color(.systemGroupedBackground))
            }
           
        }
        .onAppear {
            likemodel.fetchAllLikeById { success in
                if !success {
                } else {
                    isLoading = false
                }
            }
        }
    }
}

struct LikeRow: View {
    var like: GetLike
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(like.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("User: \(like.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("User ID: \(like.user_id)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
