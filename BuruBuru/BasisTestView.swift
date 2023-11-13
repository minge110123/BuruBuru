//
//  BasisTestView.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/13.
//

import SwiftUI


struct BasisTestView: View {
    
    @State private var showCountdown = false
    @State private var timeRemaining = 30
    @State private var showAlert = false
    private var motionManager = MotionManager()
    
    
    var body: some View {
        NavigationStack {
            
            
            VStack {
                
                
                if showCountdown {
                    Text("\(timeRemaining)s")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                        .padding(20)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(10)
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            } else {
                                self.showAlert = true
                                
                                motionManager.stopUpdates()
                                
                            }
                        }
                } else {
                    Image("handPhone")
                        .resizable()
                        .scaledToFit()
                    
                    Text("スマホをきなるべる水平で３０秒キープしてください")
                        .font(.title)
                        .padding()
                }
                
                
                
                Spacer()
                
                
                
                
                Button(action: {
                    motionManager.startUpdates()
                    startCountdown()
                    
                    
                }) {
                    Text("開始")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("測定完了"),
                    message: Text(""),
                    primaryButton: .default(Text("もう一度"), action: startCountdown),
                    secondaryButton: .cancel(Text("完了"), action: viewResults)
                )
            }
            
            
            
            .navigationTitle("標準測定")
        }
    }
    
    
    func startCountdown() {
        showCountdown = true
        timeRemaining = 3
        
        motionManager.startUpdates()
     
    }
    
    func viewResults() {
        showCountdown = false
        
        motionManager.saveDataToFile()
        motionManager.data = []
        
        
    }
    
}

#Preview {
    BasisTestView()
}
