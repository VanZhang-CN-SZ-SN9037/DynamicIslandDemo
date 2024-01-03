//
//  ProuctActivityAttributes.swift
//   
//
//  Created by VanZhang on 2024/1/3.
//

import Foundation
import ActivityKit

class ActivityBusinessBaseModel: NSObject ,Codable{
    var productId: String = ""
    init(productId: String) {
        self.productId = productId
    }
}

public struct ProuctActivityContentState: Codable, Hashable {
    var productId: String
    // 在实际开发中,这里添加数据模型,通过数据模型来保证传参
    var model: ActivityBusinessBaseModel? {
        didSet{
            if let pid = model?.productId {
                productId = pid
            }
        }
    }
}

public struct ProuctActivityAttributes: ActivityAttributes {
    public typealias ContentState = ProuctActivityContentState
    var contentState:ProuctActivityContentState?
    
    let title1: String
    let title2: String
    let image: String
    
    init(contentState: ProuctActivityContentState? = nil, title1: String, title2: String, image: String) {
        self.contentState = contentState
        self.title1 = title1
        self.title2 = title2
        self.image = image
    }
}
