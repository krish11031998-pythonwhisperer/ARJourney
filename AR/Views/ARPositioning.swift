//
//  ARPositioning.swift
//  AR
//
//  Created by Krishna Venkatramani on 05/04/2023.
//

import Foundation
import ARKit

class ARPositioningViewController: GenericARView {
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func setupView() {
        super.setupView()
        let stack: UIStackView = .init(arrangedSubviews: [addButton, .spacer(), resetButton])
        stack.axis = .horizontal
        
        addButton.setWidth(width: 100)
        addButton.layer.cornerRadius = 12
        
        resetButton.setWidth(width: 100)
        resetButton.layer.cornerRadius = 12
        
        addButton.addTapGesture(addShapes)
        resetButton.addTapGesture(reset)
        
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, leading: 16, trailing: 16, bottom: 20)
    }
    
    private func addBox() {
        let box = SCNTorus(ringRadius: 0.3, pipeRadius: 0.1)
        box.firstMaterial?.diffuse.contents = UIColor.red
        box.firstMaterial?.specular.contents = UIColor.blue
        let boxNode = SCNNode(geometry: box)
        //boxNode.position = .init(randomNumbers(firstNum: -0.3, secondNum: 0.3), randomNumbers(firstNum: -0.3, secondNum: 0.3), randomNumbers(firstNum: -0.3, secondNum: 0.3))
        //
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    private func addShapes() {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: .init(x: 0, y: 0.2))
        path.addLine(to: .init(x: 0.3, y: 0.3))
        path.addLine(to: .init(x: 0.6, y: 0.2))
        path.addLine(to: .init(x: 0.6, y: 0))
        path.close()
        let geometry = SCNShape(path: path, extrusionDepth: 0.2)
        geometry.firstMaterial?.diffuse.contents = UIColor.red
        geometry.firstMaterial?.specular.contents = UIColor.blue
        let node = SCNNode(geometry: geometry)
        node.position = .init(0, 0, -0.4)
        sceneView.scene.rootNode.addChildNode(node)
        
        node.eulerAngles = .init(CGFloat.pi/2, 0, 0)
        
        //Door
        let plane = SCNPlane(width: 0.05, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIColor.brown
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = .init(0.3, 0.07, 0.13)
        node.addChildNode(planeNode)
    }
    
    private func reset() {
        sceneView.session.pause()
        sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }

}
