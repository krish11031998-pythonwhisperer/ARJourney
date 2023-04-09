//
//  ArGameViewController.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import UIKit
import Combine
import ARKit

class ARGameViewController: GenericARView {
    private lazy var playButton: UIButton = { .buildGenericButton(title: "Play", color: .green) }()
    private lazy var resetButton: UIButton = { .buildGenericButton(title: "Reset", color: .red) }()
    
    private lazy var jellyFishNode: SCNNode? = {
        let scene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        return scene?.rootNode.childNodes.first
    }()
    
    override func setupView() {
        super.setupView()
        let stack = UIStackView(arrangedSubviews: [playButton, .spacer(), resetButton])
        stack.axis = .horizontal
        playButton.addTapGesture { [weak self] in
            print("(DEBUG) Clicked on Play")
            self?.placeJellyFish()
        }
        
        resetButton.addTapGesture { [weak self] in
            guard let self else { return }
            self.resetARScene()
            print("(DEBUG) Clicked on Reset")
        }
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, leading: 24, trailing: 24, bottom: 50, centerX: 0)
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        showDebugOptions = false
        sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func placeJellyFish() {
        guard sceneView.scene.rootNode.childNode(withName: "jelly", recursively: true) == nil else { return }
        let plainNode = SCNNode(geometry: SCNPlane(width: 0.2, height: 0.2))
        plainNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        let node = jellyFishNode ?? plainNode
        node.scale = .init(0.1, 0.1, 0.1)
        node.position = .init(.randomNumbers(firstNum: 0, secondNum: 0.1),
                              .randomNumbers(firstNum: 0, secondNum: 0.1),
                              .randomNumbers(firstNum: 0, secondNum: 0.1))
        node.name = "jelly"
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        guard
            let view = sender.view as? ARSCNView
        else { return }
        
        let location = sender.location(in: view)
        let hitTest = view.hitTest(location)
        
        if let firstNode = hitTest.first?.node {
            print("(DEBUG) Tapped on : \(firstNode) with position: \(firstNode.position) -> hitTest: \(hitTest)")
            if firstNode.animationKeys.isEmpty {
                SCNTransaction.begin()
                animateNode(node: firstNode)
                SCNTransaction.completionBlock = { [weak self] in
                    firstNode.removeFromParentNode()
                    self?.placeJellyFish()
                }
                SCNTransaction.commit()
            }
        } else {
            print("(DEBUG) Didn't Tap on anything!")
        }
    }
    
    private func animateNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        let initial = node.presentation.position
        spin.fromValue = initial
        spin.toValue = SCNVector3(initial.x - 0.2, initial.y - 0.2, initial.z - 0.2)
        spin.duration = 0.1
        spin.repeatCount = 5
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
    }
}
