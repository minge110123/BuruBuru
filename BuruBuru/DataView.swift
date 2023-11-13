//
//  DataView.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/14.
//

import SwiftUI

struct DataView: View {
    @State private var motionSessions: [[MotionData]] = []
     var motionManager = MotionManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(motionSessions.indices, id: \.self) { index in
                    NavigationLink(destination: DetailView(sessionData: motionSessions[index])) {
                        Text("テスト \(index + 1)")
                    }
                }
                .onDelete(perform: deleteSession)
            }.safeAreaPadding(.all)
            .navigationTitle("データ")
            .onAppear {
                motionSessions = motionManager.loadDataFromFile()
            }
        }
    }

    private func deleteSession(at offsets: IndexSet) {
        for index in offsets {
            motionManager.deleteSession(at: index)
        }
        motionSessions = motionManager.loadDataFromFile()
    }

}



// Preview
struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(motionManager: MotionManager())
    }
}
