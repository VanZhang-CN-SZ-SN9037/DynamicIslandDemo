//
//  TestBusinessModel.swift
//  DynamicIslandDemo
//
//  Created by VanZhang on 2024/1/3.
//

import Foundation

class TestBusinessModel:ActivityBusinessBaseModel {
    var Id: String
     init(Id: String = UUID().uuidString) {
         self.Id = Id
         super.init(productId:Id)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
