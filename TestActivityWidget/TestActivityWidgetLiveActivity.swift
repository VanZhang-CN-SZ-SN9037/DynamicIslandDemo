//
//  TestActivityWidgetLiveActivity.swift
//  TestActivityWidget
//
//  Created by VanZhang on 2024/1/3.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TestActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ProuctActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
               
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                } 
                DynamicIslandExpandedRegion(.center) {
                    Text("Center")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
//                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
//                Text("L")
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<5) { Identifiable in
                        Image(systemName: "star.fill")
                    }
                }
            } compactTrailing: {
//                Text("T \(context.state.emoji)")
                
                Text("T")
            } minimal: {
//                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
 
