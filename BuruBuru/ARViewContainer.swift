//
//  ARViewContainer.swift
//  BuruBuru
//
//  Created by ZML on 2023/11/14.
//

import SwiftUI
import ARKit

struct ARViewContainer: UIViewControllerRepresentable {

    @Binding var isDrawing: Bool
    
    
    
    

    class Coordinator: NSObject, ARSCNViewDelegate {

        var nodes = [TimestampedNode]()
        var detectedPlanes = [ARPlaneAnchor: SCNNode]()
        var imageAdded = false
        var isDrawing: Bool {
            didSet {
                if !isDrawing {
                    cameraIndicator?.removeFromParentNode()
                    cameraIndicator = nil
                }
            }
        }
        var cameraIndicator: SCNNode?

        init(isDrawing: Bool) {
            self.isDrawing = isDrawing
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

            let planeNode = SCNNode()
            node.addChildNode(planeNode)
            detectedPlanes[planeAnchor] = planeNode

            if !imageAdded {
                var images = ["8","2","3","6","rbt"]
                let randomIndex = Int.random(in: 0..<images.count)
                let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width*0.5), height: CGFloat(planeAnchor.planeExtent.height*0.5))
                plane.firstMaterial?.diffuse.contents = UIImage(named: images[randomIndex])
                let imageNode = SCNNode(geometry: plane)
                imageNode.eulerAngles.x = -.pi / 2
                planeNode.addChildNode(imageNode)
                imageAdded = true
            }
        }

        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let arView = renderer as? ARSCNView,
                  let currentFrame = arView.session.currentFrame else {
                print("Failed")
                return
            }
            
            let transform = currentFrame.camera.transform
            let cameraPosition = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)

            guard let firstPlaneNode = detectedPlanes.values.first else {
                print("No detected plane to draw on.")
                return
            }
            
            let projectedPosition = firstPlaneNode.convertPosition(cameraPosition, from: nil)
            var fixedPosition = projectedPosition
            fixedPosition.y = 0

            if !isDrawing {
                if cameraIndicator == nil {
                    let indicator = SCNNode()
                    indicator.geometry = SCNSphere(radius: 0.005)
                    indicator.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                    arView.scene.rootNode.addChildNode(indicator)
                    cameraIndicator = indicator
                }
                cameraIndicator?.position = firstPlaneNode.convertPosition(fixedPosition, to: nil)
            } else {
                cameraIndicator?.removeFromParentNode()
                cameraIndicator = nil

                let trailNode = SCNNode()
                trailNode.geometry = SCNSphere(radius: 0.005)
                trailNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                trailNode.position = firstPlaneNode.convertPosition(fixedPosition, to: nil)
                trailNode.renderingOrder = 10  // Ensure it's rendered above the image
                arView.scene.rootNode.addChildNode(trailNode)
                
                let currentTime = CFAbsoluteTimeGetCurrent()
                let timestampedNode = TimestampedNode(node: trailNode, timestamp: currentTime)
                self.nodes.append(timestampedNode)
            }
        }

        struct TimestampedNode {
            let node: SCNNode
            let timestamp: CFAbsoluteTime
        }

        func removeOldNodes() {
            let currentTime = CFAbsoluteTimeGetCurrent()
            nodes = nodes.filter { timestampedNode in
                let nodeAge = currentTime - timestampedNode.timestamp
                if nodeAge > 10 {
                    timestampedNode.node.removeFromParentNode()
                    return false
                }
                return true
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isDrawing: isDrawing)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let arViewController = UIViewController()
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        arViewController.view = arView
        return arViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.removeOldNodes()
        context.coordinator.isDrawing = self.isDrawing
    }
}

