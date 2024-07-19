//
//  ExersiceListView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 17/7/24.
//

import SwiftUI

struct ExersiceListView: View {
    @Binding var isOpen :Bool
    @State var searchText = ""
    @State var isLoading = false
    @ObservedObject var modelEx : ExersiceViewModel
    var body: some View {
            NavigationStack{
                if isLoading {
                    LoadingView()
                }else {
                    VStack{
                        HStack{
                            Button(action: {isOpen = false}, label: {Text("back")})
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black.opacity(0.2))
                                TextField("Search", text: $searchText)
                                
                            }.padding([.leading, .trailing])
                                .overlay{
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black.opacity(0.2),lineWidth: 2)
                                }
                        }.padding([.leading, .trailing])
                        ScrollView{
                            ForEach(filteredExersices, id: \.id) { exersice in
                                NavigationLink {
                                    DetailExersice(exersice: exersice)
                                } label: {
                                    ExersiceItemView(exersice: exersice)
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
    
    private var filteredExersices: [Exersice] {
        if searchText.isEmpty {
            return modelEx.exersices
        } else {
            return modelEx.exersices.filter {
                ($0.name.lowercased().contains(searchText.lowercased())
                 )
            }
        }
    }
}

