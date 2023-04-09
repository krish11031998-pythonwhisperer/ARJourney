//
//  File.swift
//  AR
//
//  Created by Krishna Venkatramani on 05/04/2023.
//

import Foundation
import UIKit
import ARKit

enum TableARComponents {
    case legs
    case tableTop
}

extension TableARComponents {
    func node() -> SCNNode {
        var node: SCNNode
        switch self {
        case .legs:
            let geometry = SCNCylinder(radius: 0.025, height: 0.5)
            geometry.firstMaterial?.diffuse.contents = UIColor.black.cgColor
            node = .init(geometry: geometry)
        case .tableTop:
            let geometry = SCNBox(width: 1, height: 0.05, length: 0.4, chamferRadius: 0.2)
            geometry.firstMaterial?.diffuse.contents = UIColor.brown.cgColor
            node = .init(geometry: geometry)
        }
        return node
    }
}

class TableARController: UIViewController {
    
    private lazy var sceneView: ARSCNView = { .init() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
    }
    
    private func setupView() {
        sceneView.scene = SCNScene()
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTable() {
        //MARK: LegOne
        let legOne = TableARComponents.legs.node()
        legOne.position = SCNVector3(0, -0.25, -0.5)
        
        //MARK: - LegTwo
        let legTwo = TableARComponents.legs.node()
        legTwo.position = SCNVector3(0, -0.25, -0.8)
        
        //MARK: - LegThree
        let legThree = TableARComponents.legs.node()
        legThree.position = SCNVector3(0.8, -0.25, -0.8)
        
        //MARK: - LegFour
        let legFour = TableARComponents.legs.node()
        legFour.position = SCNVector3(0.8, -0.25, -0.5)
        
        //MARK: - TableTop
        let tableTop = TableARComponents.tableTop.node()
        tableTop.position = SCNVector3(0.4, 0, -0.65)
        
        let light = SCNLight()
        light.type = .ambient
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.eulerAngles.y = -.pi/4
        sceneView.scene.rootNode.addChildNode(lightNode)
        
        [legOne, legTwo, legThree, legFour, tableTop].forEach {
            sceneView.scene.rootNode.addChildNode($0)
        }
    }
    
    
    
}
