//
//  Drunk.swift
//  VideoProcessWithMetal
//
//  Created by tomisacat on 07/01/2018.
//  Copyright © 2018 tomisacat. All rights reserved.
//

import Foundation
import Metal
import UIKit

class Drunk: ShaderProtocol {
    private var computePipelineState: MTLComputePipelineState?
    var identifier: String
    
    init() {
        computePipelineState = MetalManager.shared.makeComputePipelineState(functionName: "drunk")
        identifier = String.random()
    }
    
    func encode(commandBuffer: MTLCommandBuffer, sourceTexture: MTLTexture, destinationTexture: MTLTexture) {
        guard let cps = computePipelineState else {
            return
        }
        
        let computeCommandEncoder = commandBuffer.makeComputeCommandEncoder()
        computeCommandEncoder?.setComputePipelineState(cps)
        computeCommandEncoder?.setTexture(sourceTexture, index: 0)
        computeCommandEncoder?.setTexture(destinationTexture, index: 1)
        
        var diff = Float(CACurrentMediaTime() - MetalManager.shared.beginTime)
        computeCommandEncoder?.setBytes(&diff, length: MemoryLayout<Float>.size, index: 0)
        computeCommandEncoder?.dispatchThreadgroups(sourceTexture.threadGroups(pipeline: cps),
                                                    threadsPerThreadgroup: sourceTexture.threadGroupCount(pipeline: cps))
        computeCommandEncoder?.endEncoding()
    }
}