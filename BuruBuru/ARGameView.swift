//
//  ARGameView.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/21.
//


import SwiftUI

struct ARGameView: View {
    
    @State private var isStart = true
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var showAlert = false
    @State private var isButton = true
    private var motionManager = MotionManager()
    
    
    var body: some View {
        NavigationStack {
            
            
            VStack {
                if isStart{
                    Image("roboto")
                        .resizable()
                        .scaledToFit()
                    
                    Text("スマホの移動にロボットを操作して３０秒でテレビを修理してください")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding()
                }else{
                    
                    VStack {
                        ARGameTest(score:$score)
                            .frame(width: 400,height: 400)
                            .padding()
                        Text("Score: \(score)")
                        Text("\(timeRemaining)s")
                            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                                if self.timeRemaining > 0 {
                                    self.timeRemaining -= 1
                                } else {
                                    self.showAlert = true
                                    
                                    motionManager.stopUpdates()
                                    
                                }
                            }
                    }
                    
                    
                    
                }
                
                
                
            }
            
            Spacer()
            
            
            
            
            Button(action: {
                
                if isButton{
                    motionManager.startUpdates()
                    startCountdown()
                    isButton = false
                    
                }else{
                    isButton = true
                    stop()
                    
                }
               
                
            }) {
                Text(isButton ? "開始" : "停止")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            
            .navigationTitle("ARゲーム")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("測定完了"),
                message: Text("修理したテレビ数：\(score)"),
                primaryButton: .default(Text("もう一度"), action: startCountdown),
                secondaryButton: .cancel(Text("完了"), action: viewResults)
            )
        }
        
        
        
        
    }
    func startCountdown() {
        isStart = false
        timeRemaining = 15
        
        motionManager.startUpdates()
     
    }
    
    func viewResults() {
        isStart = true
        isButton = true
        
        motionManager.saveDataToFile()
        motionManager.data = []
        
        
    }
    
    func stop(){
        isStart = true
        
        motionManager.data = []
    }
    
}




#Preview {
    ARGameView()
}
