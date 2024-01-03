//
//  ActivityDataManager.swift
//
//
//  Created by VanZhang on 2024/1/3.
//

import Foundation
import ActivityKit


extension Notification.Name {
    public static let liveActivityNotification = Notification.Name(rawValue: "liveActivityNotif")
}

// 通过此工具类,实现 业务数据模型 与 Activity 匹配（activity的Id 和 productId）
// productId 的实参 可以是某商品id,也可以是某业务类型的 某id
struct ActivityDataManager {
    // 保留商品的预约状态，key是商品id，value是activity的id
    static let productIds = "com.superApp.activity.business.productIds"
    
    static func checkIsHaveProduct(productId: String) -> Bool {
        if let ids = UserDefaults.standard.value(forKey: ActivityDataManager.productIds) as? [String: String] {
            // 本地缓存包含该商品ID，并且系统的Activity依旧存在
            if ids.keys.contains(productId) {
                for activity in Activity<ProuctActivityAttributes>.activities where activity.id == ids[productId] {
                    return true
                }
            }
        }
        return false
    }

    static func saveActivityIdForProduct(productId: String, activityId: String) {
        var ids = [String: String]()
        if let tempIds = UserDefaults.standard.value(forKey: ActivityDataManager.productIds) as? [String: String] {
            ids = tempIds
        }
        ids[productId] = activityId
        UserDefaults.standard.set(ids, forKey: ActivityDataManager.productIds)
    }
    
    static func getProductActivityId(productId: String) -> String? {
        if let ids = UserDefaults.standard.value(forKey: ActivityDataManager.productIds) as? [String: String] {
            return ids[productId]
        }
        return nil
    }
    
    static func removeProductActivityId(productId: String) {
        if var ids = UserDefaults.standard.value(forKey: ActivityDataManager.productIds) as? [String: String] {
            ids.removeValue(forKey: productId)
            UserDefaults.standard.set(ids, forKey: ActivityDataManager.productIds)
        }
    }
}

extension ActivityDataManager {
    // 注册 灵动岛活动
    static func registerDynamicActivity(model: ActivityBusinessBaseModel) {
        
        if !ActivityAuthorizationInfo().areActivitiesEnabled {
            debugPrint("不支持灵动岛")
            return
        }
        
        do {
            let contentState = ProuctActivityContentState(productId: model.productId,model: model)
            let attributes = ProuctActivityAttributes(contentState: contentState, title1: "title1", title2: "title2", image: "image")
            let activity = try Activity.request(attributes: attributes, contentState: contentState)
            debugPrint("activityId:\(activity.id)")
            ActivityDataManager.saveActivityIdForProduct(productId: contentState.productId, activityId: activity.id)
            debugPrint("registerDynamicActivity succeed")
        } catch {
            debugPrint("registerDynamicActivity Fail")
        }
        let activities = Activity<ProuctActivityAttributes>.activities
        print(activities)
         
    }

    static func unregisterDynamicActivity(productId: String) {
        if let activityId = ActivityDataManager.getProductActivityId(productId: productId) {
            for activity in Activity<ProuctActivityAttributes>.activities where activity.id == activityId {
                Task {
                    await activity.end(dismissalPolicy:.immediate)
                }
                debugPrint("关闭一个Activity:\(activityId)")
            }
        }
    }
}

// 解析灵动岛的传递数据，做相应的事件，这里通过通知给主工程的控制器执行相应任务
// 结合业务逻辑来处理！！！
struct ActivityBrigde {
    @discardableResult
    public static func activityAction(url: URL) -> Bool {
        let host = url.host
        guard host != nil else { return false }
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
        guard let queryItems = queryItems else { return false }
        var productId : String?
        var name : String?
        for item in queryItems {
            // 获取商品id和名称
            if item.name == "productId" {
                productId = item.value
            }
            else if item.name == "name" {
                name = item.value
            }
        }
        guard let productId = productId else { return false }
        debugPrint("立即抢购[\(name ?? "")] \(productId)")
        
        let info = [
            "productId": productId,
            "name": name ?? ""
        ]
        NotificationCenter.default.post(name: .liveActivityNotification, object: nil, userInfo: info)
        
        return true
    }
    
    public static func disposeNotifiMessage(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any] {
            if let content = aps["content-state"] as? [String: Any], let alert = aps["alert"] as? [String: Any] {
                if let productId = alert["productId"] as? String, let seckillFinished = content["seckillFinished"] as? Bool {
                    let activityId = ActivityDataManager.getProductActivityId(productId: productId)
//                    for activity in Activity<ProuctActivityAttributes>.activities where activityId == activity.id {
//                        let updateAtt = ProuctActivityAttributes.ContentState(seckillFinished: seckillFinished)
//                        Task {
//                            await activity.update(using: updateAtt)
//                        }
//                    }
                }
            }
        }
    }
}
