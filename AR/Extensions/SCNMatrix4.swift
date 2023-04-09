//
//  SCNMatrix4.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import ARKit

extension SCNMatrix4 {
    var orientation: SCNVector3 {
        .init(-m31, -m32, -m33)
    }
    
    var location: SCNVector3 {
        .init(m41, m42, m43)
    }
}
