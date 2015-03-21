//
//  iSangatNotificationManager.m
//  isangat
//
//  Created by Ravneet Khalsa on 3/20/15.
//  Copyright (c) 2015 isangat. All rights reserved.
//

#import "iSangatNotificationManager.h"

@implementation iSangatNotificationManager

- (void) scheduleNotifications: (NSMutableArray*)samagams {
    
    NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity: [samagams count]];
    
    for (iSangatSamagam2 *samagam in samagams) {
        [notifications addObject:[self createNotification:[self get24HoursBeforeSamagamStart:samagam]
                            body:[samagam.title stringByAppendingString:@" in 24 hours"] id:samagam.id]];
        [notifications addObject:[self createNotification:[self get1HourBeforeSamagamStart:samagam]
                            body:[samagam.title stringByAppendingString:@" in 1 hour"] id:samagam.id]];
        
    }
    
    [notifications addObject:[self createReminderNotification]];
    
    [UIApplication sharedApplication].scheduledLocalNotifications = notifications;
}

- (NSDate*) get1HourBeforeSamagamStart: (iSangatSamagam2*)samagam {
    return [samagam.startDate dateByAddingTimeInterval:-60*60];
}

- (NSDate*) get24HoursBeforeSamagamStart: (iSangatSamagam2*)samagam {
    return [samagam.startDate dateByAddingTimeInterval:-60*60*24];
}

- (UILocalNotification*) createNotification : (NSDate*)date
                                       body : (NSString*)body
                                         id : (NSString*)id {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.timeZone = [self getTimeZone:date];
    
    notification.alertBody = body;
    notification.alertAction = @"View";
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:id forKey:@"id"];
    notification.userInfo = infoDict;
    
    return notification;
}

- (NSTimeZone*) getTimeZone : (NSDate*)date {
    
    NSTimeZone *pst = [NSTimeZone timeZoneWithName:@"PST"];
    if ([pst isDaylightSavingTimeForDate:date]) {
        return [NSTimeZone timeZoneWithName:@"PDT"];
    }
    return pst;
}

- (UILocalNotification*) createReminderNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate* nextReminderDate = [[NSDate date] dateByAddingTimeInterval:[self daysFromNextFriday]*24*60*60];
    notification.fireDate = nextReminderDate;
    notification.timeZone = [self getTimeZone:nextReminderDate];
    
    notification.alertBody = @"It's been a while you have visiting iSangat app. Please open the app to get updated programs";
    notification.alertAction = @"View";
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    //Repeat the above notification every Friday if there is no activity
    notification.repeatCalendar = gregorian;
    notification.repeatInterval = NSCalendarUnitWeekOfYear;
    
    return notification;
}

- (NSInteger) daysFromNextFriday  {
   
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    
    //Friday = 5
    return 14 + (5 - weekday);
}


@end
