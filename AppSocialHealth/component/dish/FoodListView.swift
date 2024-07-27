//
//  FoodListView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 16/7/24.
//

import SwiftUI

struct FoodListView: View {
    @Binding var isOpen :Bool
    @State var searchText = ""
    @State var isLoading = false
    @ObservedObject var model: FoodViewModel
    var body: some View {
        NavigationStack{
            if isLoading {
                AnimatedPlaceHolder()
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
                        ForEach(filteredFoods, id: \.id) { food in
                            NavigationLink {
                                DetailFoodView(food: food)
                            } label: {
                                FoodItemView(food: food)
                            }
                            
                            
                        }
                    }
                }
            }
        }
//        }.onAppear{
//            isLoading = true
//            model.fetchAllFood{
//                success in
//                if success {
//                    isLoading = false
//                }else {
//                    
//                }
//                
//            }
//        }
    }
    
    
    private var filteredFoods: [Food] {
        if searchText.isEmpty {
            return model.foods
        } else {
            return model.foods.filter {
                ($0.name.lowercased().contains(searchText.lowercased())
                 )
            }
        }
    }
}

//#Preview {
//    FoodListView()
//}
