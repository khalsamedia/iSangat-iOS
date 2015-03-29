//
//  iSangatSamagam2.m
//  isangat
//
//  Created by Ravneet Khalsa on 3/9/15.
//  Copyright (c) 2015 isangat. All rights reserved.
//

#import "iSangatSamagam2.h"

@implementation iSangatSamagam2

- (instancetype) init : (NSString*) id
                title : (NSString*) title
             subTitle : (NSString*)subTitle
            startDate : (NSString*)startDate
              endDate : (NSString*)endDate
              address : (NSString*)address
                 phone: (NSString*)phone {
    
    self = [super init];
    if (self) {
        self.id = id;
        self.title = title;
        self.subTitle = subTitle;
        self.address = [self formatMapUrl:address];
        self.phone = [self formatPhone:phone];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [dateFormatter setCalendar:gregorian];
        self.startDate = [dateFormatter dateFromString:startDate];
        self.endDate = [dateFormatter dateFromString:endDate];
        self.displayDate = [self displayDate:self.startDate endDate:self.endDate];
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.id forKey:@"id"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.subTitle forKey:@"subTitle"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.startDate forKey:@"startDate"];
    [coder encodeObject:self.endDate forKey:@"endDate"];
    [coder encodeObject:self.displayDate forKey:@"displayDate"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.id = [coder decodeObjectForKey:@"id"];
    self.title = [coder decodeObjectForKey:@"title"];
    self.subTitle = [coder decodeObjectForKey:@"subTitle"];
    self.address = [coder decodeObjectForKey:@"address"];
    self.phone = [coder decodeObjectForKey:@"phone"];
    self.startDate = [coder decodeObjectForKey:@"startDate"];
    self.endDate = [coder decodeObjectForKey:@"endDate"];
    self.displayDate = [coder decodeObjectForKey:@"displayDate"];
    return self;
}

- (NSString*) formatMapUrl : (NSString*) url {
    return [url stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (NSString*) formatPhone : (NSString*) phone {
    return phone;
}

- (NSString*) displayDate : (NSDate*) startDate
                   endDate: (NSDate*) endDate {
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit units = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute;
    NSDateComponents *startDateComponents = [gregorian components:units fromDate:startDate];
    NSDateComponents *endDateComponents = [gregorian components:units fromDate:endDate];
    
    NSDateFormatter *startFormatter = [[NSDateFormatter alloc] init];
    [startFormatter setCalendar:gregorian];
    [startFormatter setDateFormat:@"EEE, MMM d hh:mm aaa"];
    
    if ( [self sameDaySamagam:startDateComponents endDate:endDateComponents]) {
        NSDateFormatter *endFormatter = [[NSDateFormatter alloc] init];
        [endFormatter setCalendar:gregorian];
        [endFormatter setDateFormat:@"hh:mm aaa"];
        return [NSString stringWithFormat:@"%@ - %@", [startFormatter stringFromDate:startDate], [endFormatter stringFromDate:endDate]];
    } else {
        return [NSString stringWithFormat:@"%@ - %@", [startFormatter stringFromDate:startDate], [startFormatter stringFromDate:endDate]];
    }
    return @"";
}

- (BOOL) sameDaySamagam : (NSDateComponents*) startDate
                endDate : (NSDateComponents*) endDate {
    return [startDate year] == [endDate year] &&
    [startDate month] == [endDate month] &&
    [startDate day] == [endDate day];
    
}


@end
