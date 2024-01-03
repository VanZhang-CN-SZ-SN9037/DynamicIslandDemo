//
//  ViewController.swift
//  DynamicIslandDemo
//
//  Created by VanZhang on 2024/1/3.
//

import UIKit
import ActivityKit

class ViewController: UIViewController {
//    private var products = [..]()
    private var remoteImageData: Data? = nil
     
    /*
     灵动岛功能的实现,关键在于:
     - 1.灵动岛Activity的注册
        - 用完之后可以update和反注册
     - 2. 灵动岛UI的适配
        - 在TestActivityWidget 内部实现（SwiftUI技术）
     灵动岛功能 可以结合 远程推送等交互一起使用
        - 解析远程推送的数据
        - 进一步处理!
     相对完整的使用Demo 可参考 https://juejin.cn/post/7153236337074634788
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchRemoteImage(urlString: "https://mmbiz.qlogo.cn/mmbiz_png/dTZZ7XS8ibTphnEzzVjvTuja1WQeGsCPpe0C8ibEwsTNz1ewCWNjECGfzwXRP224lVk3WgNRqe8Gt24e868Yewibg/0?wx_fmt=png")
        let activities = Activity<ProuctActivityAttributes>.activities
        print(activities)
        
        let testModel = TestBusinessModel(Id: "ProductId123456")
        ActivityDataManager.registerDynamicActivity(model: testModel)
//        ActivityDataManager.unregisterDynamicActivity(productId: "ProductId123456")
    }

   
}
extension ViewController{
    func fetchRemoteImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            if let imageData = data {
                self.remoteImageData = imageData
            }
        }.resume()
    }
}
