//
//  VideoPlater.swift
//  AR
//
//  Created by Krishna Venkatramani on 08/04/2023.
//

import Foundation
import UIKit
import ARKit

class VideoPlayer : GenericARView {
    
    private lazy var image: UIImage? = {
        UIImage(named: "testImageOne")
    }()
    
    private var videoPlayer: AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
    }
    
    override func runSession() {
        sceneView.scene = .init()
        
        sceneView.delegate = self
        
        guard let image = image else { return }
        let config = ARImageTrackingConfiguration()
        
        guard let cgImage = image.cgImage else { return }

        let refImage = ARReferenceImage.init(cgImage, orientation: .up, physicalWidth: 0.1)
        
        let trackedImages = Set<ARReferenceImage>(arrayLiteral: refImage)
        
        config.trackingImages = trackedImages
        config.maximumNumberOfTrackedImages = 1
    
        //sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        sceneView.session.run(config)
    }
    
    
    
    private func loadVideo() {
        guard let url = Bundle.main.url(forResource: "testVideoOne", withExtension: "mp4") else { return }
        videoPlayer = .init(playerItem: .init(url: url))
        //videoPlayer?.currentItem?.asset.
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playVideo)))
    }

    @objc
    private func playVideo(){
        videoPlayer?.play()
    }
}

extension VideoPlayer: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor, let player = videoPlayer else { return nil }
        let size = imageAnchor.referenceImage.physicalSize
        let plane = SCNPlane(width: size.width, height: size.height)

        
        let planeNode =  SCNNode(geometry: plane)
        //planeNode.position = .init(0, -0.1, -0.1)
        planeNode.eulerAngles = .init(-Float.pi/2, 0, 0)
        
//        planeNode.position.y = 0.1
        let filter = SCNChromaKeyMaterial(backgroundColor: .green )
        filter.diffuse.contents = player
        planeNode.geometry!.materials = [filter]
        
        //video does not start without delaying the player
        //playing the video before just results in [SceneKit] Error: Cannot get pixel buffer (CVPixelBufferRef)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            player.seek(to:CMTimeMakeWithSeconds(2, preferredTimescale: 1000))
        }
        // Loop video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        node.addChildNode(planeNode)
        
        return node 
    }
    
}
