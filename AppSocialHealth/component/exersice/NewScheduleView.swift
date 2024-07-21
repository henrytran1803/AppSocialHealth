//
//  NewScheduleView.swift
//  AppSocialHealth
//
//  Created by Tran Viet Anh on 19/7/24.
//

import SwiftUI

struct NewScheduleView: View {
    @ObservedObject var model = ExersiceViewModel()
    @Binding var schedule: Schedule
    @Binding var isOpen : Bool
    @State var searchText = ""
    @State var exersiceSelected = Exersice(id: 0, name: "", description: "", calorie: 0, rep_serving: 0, time_serving: 0, exersice_type: ExersiceType(id: 0, name: ""), photo: [])
    @State var id = 0
    @State var isOpenDetail = false
    var body: some View {
        GeometryReader{ geomtry in
            NavigationStack{
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
                ScrollView {
                    if let details = schedule.detail {
                        if details.isEmpty {
                            HStack{
                                Spacer()
                                Text("It's empty")
                                Spacer()
                            }
                        } else {
                            ForEach(details, id: \.id) { detail in
                                if let matchingEx = model.exersices.first(where: { $0.id == detail.exersice_id }) {
                                    
                                        ExersiceItemView(exersice: Exersice(id: matchingEx.id, name: matchingEx.name, description: matchingEx.description, calorie: matchingEx.calorie, rep_serving: detail.rep, time_serving: detail.time, exersice_type: matchingEx.exersice_type, photo: matchingEx.photo))
                                            .onTapGesture {
                                        exersiceSelected = matchingEx
                                        id = detail.id
                                        isOpenDetail = true
                                    }
                                } else {
                                    Text("Food not found")
                                }
                            }
                        }
                    } else {
                        HStack{
                            Spacer()
                            Text("It's empty")
                            Spacer()
                        }
                    }
                }
                .fullScreenCover(isPresented: $isOpenDetail){
                    DetailExersiceUpdateView(exersice: $exersiceSelected, id: id, isOpen : $isOpenDetail)
                }
            }.onAppear{
                model.fetchAllExersice{
                    success in
                    
                }
            }
            
        }
    }
}
