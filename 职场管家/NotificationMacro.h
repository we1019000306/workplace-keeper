//
//  NotificationMacro.h
//  plan
//
//  Created by Fengzy on 15/9/2.
//  Copyright (c) 2015年 Fengzy. All rights reserved.
//

#ifndef NotificationMacro_h
#define NotificationMacro_h

#define NotificationCenter [NSNotificationCenter defaultCenter]
#define UserDefaults [NSUserDefaults standardUserDefaults]

#define Notify_LogIn @"Notify_LogIn"
#define Notify_Settings_Save @"Notify_Settings_Save"
#define Notify_Plan_Save @"Notify_Plan_Save"
#define Notify_Photo_Save @"Notify_Photo_Save"
#define Notify_Task_Save @"Notify_Task_Save"
#define Notify_Messages_Save @"Notify_Messages_Save"
#define Notify_TaskRecord_Save @"Notify_TaskRecord_Save"
#define Notify_Posts_New @"Notify_Posts_New"
#define Notify_Posts_Refresh @"Notify_Posts_Refresh"
//推送通知
#define Notify_Push_LocalNotify @"Notify_Push_LocalNotify"

#define Notify_FiveDay_Tag @"20150912083000"
#define Notify_FiveDay_Time @"2015-09-12 08:30:00"

#endif
