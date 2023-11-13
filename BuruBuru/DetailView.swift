//
//  DetailView.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/14.
//

import SwiftUI

struct DetailView: View {
    
        var sessionData: [MotionData]

        var body: some View {
            VStack{
                VStack{
                    Text("リスト")
                    
                    List {
                        Section(header: HStack {
                            Text("Time").frame(width: 50, alignment: .leading)
                            Spacer()
                            Text("Roll").frame(width: 50, alignment: .leading)
                            Spacer()
                            Text("Pitch").frame(width: 50, alignment: .leading)
                            Spacer()
                            Text("Yaw").frame(width: 50, alignment: .leading)
                        }) {
                            ForEach(Array(sessionData.enumerated()), id: \.offset) { index, entry in
                                HStack {
                                    Text("\((Double(index) * 0.1), specifier: "%.1f")s").frame(width: 50, alignment: .leading)
                                    Spacer()
                                    Text("\(entry.roll, specifier: "%.2f")").frame(width: 50, alignment: .leading)
                                    Spacer()
                                    Text("\(entry.pitch, specifier: "%.2f")").frame(width: 50, alignment: .leading)
                                    Spacer()
                                    Text("\(entry.yaw, specifier: "%.2f")").frame(width: 50, alignment: .leading)
                                }
                            }
                        }
                    }.frame(width: 400, height: 300)
                }
                
                //gurahu
                
                ScrollView{
                    VStack{
                        Text("グラフ")
                        HStack{
                            Text("Roll")
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                        
                            
                        LineChartView(data: sessionData.map { $0.roll })
                            .frame(height: 200)
                            .padding()
                        
                        HStack{
                            Text("Pitch")
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                        // Repeat for pitch and yaw
                        LineChartView(data: sessionData.map { $0.pitch })
                            .frame(height: 200)
                            .padding()
                        
                        HStack{
                            Text("Yaw")
                                .font(.title)
                                .padding()
                            Spacer()
                        }
                        LineChartView(data: sessionData.map { $0.yaw })
                            .frame(height: 200)
                            .padding()
                    }
            
                }
                
                
                
                
            }
            
        }
    }


struct LineChartView: View {
    var data: [Double]
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in self.data.indices {
                    let xPosition = geometry.size.width * CGFloat(index) / CGFloat(self.data.count - 1)
                    let yPosition = geometry.size.height * (1 - CGFloat((self.data[index] + 1) / 2))  // Assuming values range from -1 to 1
                    let point = CGPoint(x: xPosition, y: yPosition)
                    if index == 0 {
                        path.move(to: point)
                    } else {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}


#Preview {
    DetailView(sessionData: [])
}
