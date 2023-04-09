//
//  GenericARView.swift
//  AR
//
//  Created by Krishna Venkatramani on 05/04/2023.
//

import Foundation
import ARKit


class GenericARView: UIViewController {
    
    private(set) var sceneView: ARSCNView = { .init() }()
    var showDebugOptions: Bool = false {
        didSet {
            if showDebugOptions {
                sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        runSession()
    }
    
    func setupView() {
        sceneView.scene = SCNScene()
        view.addSubview(sceneView)
        view.setFittingConstraints(childView: sceneView, insets: .zero)
    }
    
    func runSession() {
        let config = ARWorldTrackingConfiguration()
        if showDebugOptions {
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        }
        sceneView.showsStatistics = true
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func resetARScene(removeChildNodes: Bool = true) {
        sceneView.session.pause()
        if removeChildNodes {
            sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        }
        sceneView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
}
