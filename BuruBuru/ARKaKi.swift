//
//  ARKaKi.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/14.
//

import SwiftUI

struct ARKaKi: View {
    @State private var isDrawing = false
    @State var isStart = true
    @State private var showAlert = false
    private var motionManager = MotionManager()
    enum ButtonState {
        case start
        case kakihajime
        case stop
    }
    @State private var buttonState = ButtonState.start
    
    
    var body: some View {
        NavigationStack {
            
            
            VStack {
                if isStart{
                    Image("rb")
                        .resizable()
                        .scaledToFit()
                    
                    Text("平面の上に開始を押して、図の通りにスマホの移動で書いてくだいさい")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                }else{
                    
                    ARViewContainer(isDrawing: $isDrawing)
                        .frame(width: 400,height: 400)
                    
                    
                }
                
                
                
            }   
            
            Spacer()
            
            
            
            
            Button(action: {
                
                switch buttonState {
                            case .start:
                                buttonState = .kakihajime
                                isStart = false
                            case .kakihajime:
                                buttonState = .stop
                                isDrawing = true
                            motionManager.startUpdates()
                            case .stop:
                                buttonState = .start
                                showAlert = true
                    isDrawing = false
                                
                           
                            
                          
                        
                                
                            }
                
            }) {
                
                switch buttonState {
                    case .start:
                        Text("开始")
                    case .kakihajime:
                        Text("書き初め")
                    case .stop:
                        Text("終わり")
                    }
                    
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            
            
            .navigationTitle("AR書き")
        } .alert(isPresented: $showAlert) {
            Alert(
                title: Text("测试完成"),
                message: Text("请选择您的下一步操作。"),
                primaryButton: .default(Text("完成")) {
                    motionManager.saveDataToFile()
                    motionManager.stopUpdates()
                    isStart = true
                    isDrawing = false
                },
                secondaryButton: .default(Text("重试")) {
                    
                    isStart = true
                    isDrawing = false
                }
            )
        }
        
        
        
    }
}

#Preview {
    ARKaKi()
}
