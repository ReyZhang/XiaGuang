//
//  YTLocalMerchantInstance.h
//  HighGuang
//
//  Created by Yuan Tao on 9/2/14.
//  Copyright (c) 2014 Yuan Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "YTDataManager.h"
#import "YTLocalMall.h"
#import "YTMerchantLocation.h"
#import <AVOSCloud/AVOSCloud.h>
#import "YTLocalDoor.h"
#define CLOUD_MERCHANT_CLASS_NAME @"Merchant"
@interface YTLocalMerchantInstance : NSObject<YTMerchantLocation>

-(id)initWithDBResultSet:(FMResultSet *)findResultSet;

@end
