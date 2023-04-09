//
//  SCNVector3.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import ARKit

extension SCNVector3 {
    
    static func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        .init(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
}
