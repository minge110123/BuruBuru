//
//  motionManger.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/14.
//

import Foundation
import CoreMotion

struct MotionData: Codable, Hashable {
    var roll: Double
    var pitch: Double
    var yaw: Double

    static func == (lhs: MotionData, rhs: MotionData) -> Bool {
        lhs.roll == rhs.roll && lhs.pitch == rhs.pitch && lhs.yaw == rhs.yaw
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(roll)
        hasher.combine(pitch)
        hasher.combine(yaw)
    }
}

class MotionManager {
    private var motionManager = CMMotionManager()
    private var timer: Timer? = nil

     var roll: Double = 0.0
     var pitch: Double = 0.0
     var yaw: Double = 0.0
     var data: [MotionData] = []

    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1

            let backgroundQueue = OperationQueue()
            backgroundQueue.qualityOfService = .background

            motionManager.startDeviceMotionUpdates(to: backgroundQueue) { [weak self] (motion, error) in
                guard let self = self, let motion = motion else { return }

                
                let roll = motion.attitude.roll
                let pitch = motion.attitude.pitch
                let yaw = motion.attitude.yaw

                
                DispatchQueue.main.async {
                    self.roll = roll
                    self.pitch = pitch
                    self.yaw = yaw
                    self.data.append(MotionData(roll: roll, pitch: pitch, yaw: yaw))
                }
            }
        }
    }


    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
        
    }

    func saveDataToFile() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("motionData.json")

        var savedData = loadDataFromFile() 
        savedData.append(self.data)  // Append the current session as a single entry

        do {
            let data = try JSONEncoder().encode(savedData)
            try data.write(to: fileURL)
        } catch {
            print("Error saving data to file: \(error)")
        }
    }


    func loadDataFromFile() -> [[MotionData]] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("motionData.json")

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            return []
        }

        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([[MotionData]].self, from: data)
        } catch {
            print("Error loading data from file: \(error)")
            return []
        }
    }
    
    func deleteSession(at index: Int) {
        var savedData = loadDataFromFile()
        guard index < savedData.count else { return }
        savedData.remove(at: index)

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("motionData.json")

        do {
            let data = try JSONEncoder().encode(savedData)
            try data.write(to: fileURL)
        } catch {
            print("Error saving data after deletion: \(error)")
        }
    }


}
