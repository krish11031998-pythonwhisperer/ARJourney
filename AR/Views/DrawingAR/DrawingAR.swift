//
//  DrawingAR.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import UIKit
import Combine
import ARKit

class DrawingARApp: GenericARView {
    
    private lazy var drawButton: UIButton = {
        .buildGenericButton(title: "Draw", color: .blue) { [weak self] in
            guard let self else { return }
            self.isDrawing.send(true)
        }
    }()
    
    private lazy var clearButton: UIButton = {
        .buildGenericButton(title: "Clear", color: .red) { [weak self] in
            guard let self else { return }
            self.clear.send(())
        }
    }()
    
    private lazy var drawingPointer: SCNNode = {
        let sphere = SCNSphere(radius: 0.02)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: sphere)
        node.name = "pointer"
        return node
    }()
    
    private var isDrawing: CurrentValueSubject<Bool, Never> = .init(false)
    private var clear: PassthroughSubject<Void, Never> = .init()
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        sceneView.delegate = self
        bind()
    }
    
    override func setupView() {
        super.setupView()
        let stack = UIStackView()
        stack.axis = .horizontal
        [drawButton, .spacer(), clearButton].forEach(stack.addArrangedSubview)
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, leading: 24, trailing: 24, bottom: 50, centerX: 0)
        drawButton.addTapGesture { [weak self] in
            guard let self else { return }
            self.isDrawing.send(!self.isDrawing.value)
        }
        
        sceneView.scene.rootNode.addChildNode(drawingPointer)
    }
    
    private func bind() {
        isDrawing
            .sink { [weak self] status in
                print("(DEBUG) isSelected: \(status)")
                self?.drawButton.backgroundColor = status ? .green : .blue
            }
            .store(in: &bag)
        
        clear
            .sink { [weak self] _ in
                self?.sceneView.scene.rootNode.enumerateChildNodes { node, _ in
                    if node.name != "pointer" {
                        node.removeFromParentNode()
                    }
                }
            }
            .store(in: &bag)
    }
    
    private func addDottedSpheres() -> SCNNode {
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.02))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        return sphere
    }
}

extension DrawingARApp: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = transform.orientation
        let location = transform.location
        let currentCameraLocation = orientation + location
        drawingPointer.position = currentCameraLocation
        if isDrawing.value {
            let sphere = addDottedSpheres()
            sphere.position = currentCameraLocation
            sceneView.scene.rootNode.addChildNode(sphere)
        }
    }
}
