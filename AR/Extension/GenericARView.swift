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
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}
