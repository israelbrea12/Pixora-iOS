//
//  HomeView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = Resolver.shared.resolve(HomeViewModel.self)
    
    var body: some View {
        NavigationStack{
            ZStack(
                content:{
                    switch homeViewModel.state{
                    case .initial,
                         .loading:
                        loadingView()
                    case .success:
                        successView()
                    case .error(let errorMessage):
                        errorView(errorMsg:errorMessage)
                    default:
                        emptyView()
                    }
                }
            )
            .navigationTitle("Photos")
        }
    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func successView() -> some View {
        List{
            ForEach(homeViewModel.photos){ photo in
                ZStack(
                content:{
                    PhotoRow(photo: photo, removeAction: nil)
//                    NavigationLink(destination: CharacterDetailView(character: character).toolbar(.hidden, for: .tabBar)){
//                        EmptyView() //Label
//                    }
                }) //ZStack
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 16))
            }
        } //List
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
    
    private func emptyView() -> some View {
        InfoView(message: "No data found")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

