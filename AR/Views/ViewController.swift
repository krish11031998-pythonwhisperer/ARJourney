//
//  ViewController.swift
//  ARTutorial
//
//  Created by Krishna Venkatramani on 04/04/2023.
//

import UIKit
import RealityKit
import SceneKit
import ARKit

class ViewController: UIViewController {
   
    private lazy var sceneView: ARSCNView =  { .init() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        createShape()
        addLights()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
        
    }
    
    private func setupScene() {
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createShape() {
        let shapes: [SCNGeometry] = [
            SCNPyramid(width: 0.2, height: 0.2, length: 0.2),
            SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0),
            SCNSphere(radius: 0.2)
        ]
        
        let colors: [UIColor] = [.red, .green, .blue]
        
        for (_shape, color) in zip(shapes.enumerated(), colors) {
            let shape = _shape.element
            let idx = _shape.offset
            shape.firstMaterial?.diffuse.contents = color.cgColor
            let node = SCNNode(geometry: shape)
            node.position = SCNVector3(Double(1 - idx) * 0.5, 0, -0.8)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    private func addLights() {
        let light = SCNLight()
        light.type = .directional
        let node = SCNNode()
        node.light = light
        node.eulerAngles.x = -.pi/4
        sceneView.scene.rootNode.addChildNode(node)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.gray.cgColor
        let ambientNode = SCNNode()
        ambientNode.light = ambientLight
        ambientNode.eulerAngles.x = -.pi/4
        sceneView.scene.rootNode.addChildNode(ambientNode)
    }
    
    
}

extension ViewController: ARSCNViewDelegate {
    
}
