//
//  UtilMacro.h
//  职场管家
//
//  Created by Jackie Liu on 16/1/25.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#ifndef UtilMacro_h
#define UtilMacro_h

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)


#define ViewOriginY (IS_iOS7 ? 64:0)
#endif /* UtilMacro_h */
