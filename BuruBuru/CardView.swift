//
//  CardView.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/13.
//

import SwiftUI

struct CardView: View {
    
        var name:String
        var color:Color
        var present:String
        
        
        var body: some View {
            
            VStack(alignment:.leading){
                ZStack {
                    
                    Rectangle()
                        .fill(color)
                        .cornerRadius(10)
         
                    VStack {
                        HStack {
                            Text("\(name)")
                                    .font(.largeTitle)
                                .padding()
                            Spacer()
                        }
                        HStack {
                            Text("\(present)")
                                .padding()
                            
                        }
                        
                        Spacer()
                            
                    }
                    
                            
                        
                        
                          
                       
                    
                }.padding()
                
            }.frame(width: 400,height: 200)
        }
    }

#Preview {
    CardView(name: "標準測定", color: Color.green,present: "説明、なるべる動かないようにキープ、手の振さを測定する")
        .previewLayout(.fixed(width: 400, height: 200))
}
