//
//  Planets.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import ARKit

enum Planets {
    case sun, earth, venus, moon
}

extension Planets {
    var radius: CGFloat {
        switch self {
        case .sun:
            return 0.35
        case .earth:
            return 0.2
        case .venus:
            return 0.1
        case .moon:
            return 0.02
        }
    }
    
    var diffuseContent: Any? {
        switch self {
        case .sun:
            return UIImage(named: "sun")
        case .earth:
            return UIImage(named: "earthDay")
        case .venus:
            return UIImage(named: "venus")
        case .moon:
            return UIImage(named: "moon")
        }
    }
    
    var specularContent: Any? {
        switch self {
        case .earth:
            return UIImage(named: "earthSpecular")
        default:
            return nil
        }
    }
    
    var emissionContent: Any? {
        switch self {
        case .earth:
            return UIImage(named: "earthEmission")
        case .venus:
            return UIImage(named: "venusAtmosphere")
        default:
            return nil
        }
    }
    
    var normalContent: Any? {
        switch self {
        case .earth:
            return UIImage(named: "earthNormal")
        default:
            return nil
        }
    }
    
    var rotationDuration: TimeInterval {
        switch self {
        case .venus:
            return 12
        default:
            return 8
        }
    }
    
    var position: SCNVector3 {
        switch self {
        case .sun:
            return .init(0, 0, -1)
        case .earth:
            return .init(1.2, 0, 0)
        case .venus:
            return .init(0.7, 0, 0)
        default:
            return .init(0, 0, 0)
        }
    }
    
    var hasMoon: Bool {
        switch self {
        case .sun, .moon, .venus:
            return false
        default:
            return true
        }
    }
    
}


//MARK: - PlanetNode

class PlanetNode: SCNNode {
    
    let planet: Planets
    private var moonSphere: PlanetNode!
    
    init(planet: Planets) {
        self.planet = planet
        super.init()
        setupNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        geometry = SCNSphere(radius: planet.radius)
        geometry?.firstMaterial?.diffuse.contents = planet.diffuseContent
        geometry?.firstMaterial?.specular.contents = planet.specularContent
        geometry?.firstMaterial?.emission.contents = planet.emissionContent
        geometry?.firstMaterial?.normal.contents = planet.normalContent
        position = planet.position
        if planet.hasMoon {
            setupMoon()
        }
    }
    
    private func setupMoon() {
        moonSphere = PlanetNode(planet: .moon)
        let node = SCNNode()
        node.addChildNode(moonSphere)
        node.position = .init(0, 0, 0)
        moonSphere.position = .init(planet.radius + moonSphere.planet.radius + 0.01, 0, 0)
        node.runAction(.rotateBy(x: 0, y: CGFloat(360.radians), z: 0, duration: 5).repeatForever)
        moonSphere.addRotation()
        addChildNode(node)
    }
    
    func addRotation() {
        runAction(.rotateBy(x: 0, y: CGFloat(360.radians), z: 0, duration: planet.rotationDuration).repeatForever)
    }
    
}
