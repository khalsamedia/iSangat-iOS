//
//  iSangatNotificationManager.h
//  isangat
//
//  Created by Ravneet Khalsa on 3/20/15.
//  Copyright (c) 2015 isangat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iSangatSamagam2.h"

@interface iSangatNotificationManager : NSObject

- (void) scheduleNotifications: (NSMutableArray*)samagams;

@end
