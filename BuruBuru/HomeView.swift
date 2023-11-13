//
//  HomeView.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/13.
//

import SwiftUI

struct HomeView: View {
    @State var selectedView = 1
    
    var body: some View {
        TabView(selection: $selectedView) {
            NavigationStack {
                ScrollView {
                    
                    NavigationLink(destination: BasisTestView()) {
                        
                        CardView(name: "標準測定", color: Color.red, present: "なるべる動かないようにキープで測定する")
                            .foregroundColor(Color.primary)
                    }
                    
                    NavigationLink(destination: ARKaKi()) {
                        
                        CardView(name: "AR書き", color: Color.yellow, present: "AR中書くの測定")
                            .foregroundColor(Color.primary)
                    }
                    
                    NavigationLink(destination: ARGameView()) {
                        
                        CardView(name: "ARゲーム", color: Color.blue, present: "ARゲームで測定する")
                            .foregroundColor(Color.primary)
                    }
                    
                    
                }
                .navigationTitle("Home")
            }
            
            
            
            
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(1)
            
            DataView()
                
                .tabItem {
                    Label("Data", systemImage: "list.triangle")
                }
                .tag(2)
            
            Button("Show First View") {
                selectedView = 1
            }
            .padding()
            .tabItem {
                Label("Setting", systemImage: "gearshape")
            }
            .tag(3)
            
            
        }
    }
}

#Preview {
    HomeView()
}
