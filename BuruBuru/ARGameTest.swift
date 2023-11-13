//
//  ARGameTest.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/21.
//







import SwiftUI
import ARKit
import SceneKit

struct ARGameTest: UIViewRepresentable {
    @Binding var score: Int
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ARGameTest
        var ballNode: SCNNode?
        var TvNode: SCNNode?
        var lastPlaneAnchor: ARPlaneAnchor? // 保存最近添加的平面锚点
        var lastUpdateTime: TimeInterval = 0
        let updateInterval: TimeInterval = 5 // seconds
        


        init(_ parent: ARGameTest) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            
            if self.ballNode == nil {
                let ballNode = createBallNode(planeAnchor: planeAnchor)
                self.ballNode = ballNode
                node.addChildNode(ballNode)
            }

            if self.TvNode == nil {
                let blueBallNode = createBlueBallNode(planeAnchor: planeAnchor)
                self.TvNode = blueBallNode
                node.addChildNode(blueBallNode)
            }

            self.lastPlaneAnchor = planeAnchor
        }


        private func createBallNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
               let robotNode = SCNNode()
            robotNode.loadUSDZNamed("robot_walk_idle")
                 robotNode.scale = SCNVector3(0.002, 0.002, 0.002) // Twice the size of the TV
            robotNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
               return robotNode
           }

           private func createBlueBallNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
               let tvNode = SCNNode()
               tvNode.loadUSDZNamed("tv_retro")
               tvNode.scale = SCNVector3(0.0005, 0.0005, 0.0005) // Adjust the scale as needed
               tvNode.position = randomPosition(planeAnchor: planeAnchor)
               return tvNode
           }

        private func randomPosition(planeAnchor: ARPlaneAnchor) -> SCNVector3 {
            let extent = planeAnchor.extent
            let center = planeAnchor.center

            let randomX = Float.random(in: (center.x - extent.x / 2)...(center.x + extent.x / 2))
            let randomZ = Float.random(in: (center.z - extent.z / 2)...(center.z + extent.z / 2))

            return SCNVector3(randomX, 0, randomZ)
        }


        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            if let camera = renderer.pointOfView, let planeAnchor = self.lastPlaneAnchor {
                let cameraTransform = camera.transform
                let cameraPosition = SCNVector3(cameraTransform.m41, 0, cameraTransform.m43)

                DispatchQueue.main.async {
                    self.ballNode?.position = cameraPosition
                    if self.isBallCloseToBlueBall() {
                        
                        self.moveBlueBallToNewPosition(planeAnchor: planeAnchor)
                        
                       
                        
                    }

                    // Move the blue ball randomly every few seconds
                    if time - self.lastUpdateTime > self.updateInterval {
                        self.moveBlueBallToNewPosition(planeAnchor: planeAnchor)
                        self.lastUpdateTime = time
                    }
                }
            }
        }

        private func moveBlueBallToNewPosition(planeAnchor: ARPlaneAnchor) {
            let newPosition = self.randomPosition(planeAnchor: planeAnchor)
            print("Moving blue ball to new position: \(newPosition)")
            self.TvNode?.position = newPosition
            self.parent.score += 1 
        }


        private func isBallCloseToBlueBall() -> Bool {
            guard let ballPosition = ballNode?.position, let blueBallPosition = TvNode?.position else {
                print("One of the balls is not initialized.")
                return false
            }
            let distance = distanceBetween(ballPosition, blueBallPosition)
            print("Distance between balls: \(distance)")
            return distance < 0.0009
        }

      

        private func distanceBetween(_ position1: SCNVector3, _ position2: SCNVector3) -> Float {
            let dx = position1.x - position2.x
            let dy = position1.y - position2.y
            let dz = position1.z - position2.z
            return sqrt(dx * dx + dy * dy + dz * dz)
        }
    }
}


extension SCNNode {
    func loadUSDZNamed(_ name: String) {
        guard let scene = try? SCNScene(url: Bundle.main.url(forResource: name, withExtension: "usdz")!, options: nil) else {
            print("Failed to load \(name).usdz")
            return
        }
        for childNode in scene.rootNode.childNodes {
            self.addChildNode(childNode)
        }
    }
}





