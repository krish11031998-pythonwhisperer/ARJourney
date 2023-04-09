//
//  SolarSystem.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import UIKit
import Combine
import ARKit

class SolarSystem: GenericARView {
    
    private lazy var earthSphere: PlanetNode = { .init(planet: .earth) }()
    private lazy var sunSphere: PlanetNode = { .init(planet: .sun) }()
    private lazy var venusSphere: PlanetNode = { .init(planet: .venus) }()
    
    private lazy var earthParentNode: SCNNode = {
       let node = SCNNode()
        node.addChildNode(earthSphere)
        node.position = sunSphere.position
        return node
    }()
    
    private lazy var venusParentNode: SCNNode = {
       let node = SCNNode()
        node.addChildNode(venusSphere)
        node.position = sunSphere.position
        return node
    }()
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneView.autoenablesDefaultLighting = true
        [sunSphere, earthParentNode, venusParentNode].forEach(sceneView.scene.rootNode.addChildNode)
        earthParentNode.runAction(.rotateBy(x: 0, y: CGFloat(360.radians), z: 0, duration: 14).repeatForever)
        venusParentNode.runAction(.rotateBy(x: 0, y: CGFloat(360.radians), z: 0, duration: 10).repeatForever)
        earthSphere.addRotation()
        venusSphere.addRotation()
        sunSphere.addRotation()
    }
    
}
