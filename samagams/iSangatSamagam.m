//
//  iSangatSamagam.m
//  isangat
//
//  Created by Ravneet Khalsa on 7/31/14.
//  Copyright (c) 2014 isangat. All rights reserved.
//

#import "iSangatSamagam.h"

@implementation iSangatSamagam

- (instancetype) initWithRawData : (NSString*) date
                       firstLine : (NSString*)firstLine
                      secondLine : (NSString*)secondLine
                        boldText : (NSString*)boldText
                         gmapUrl : (NSString*)gmapUrl
                         rawHtml : (NSString*)rawHtml {
    self = [super init];
    
    if(self) {
        NSString *kirtanType;
        NSString *timeAndDay;
        if(boldText != nil) {
            kirtanType = [self stringBetweenString:boldText start:@"(" andend:@")"];
            timeAndDay = firstLine;
        }
        else {
            kirtanType = [self stringBetweenString:firstLine start:@"(" andend:@")" ];
            timeAndDay = [self stringBetweenString:firstLine start:nil andend:@"("];
        }
        if(kirtanType != nil) {
            self.title = [NSString stringWithFormat:@"%@ - %@", date, kirtanType];
        } else {
            self.title = date;
        }
        
        self.description = [NSString stringWithFormat:@"%@\n%@", timeAndDay, secondLine];
        self.rawHtml = [self fixHtml:rawHtml];
        [self setStartAndEndDate:date timeAndDay:timeAndDay];
    }
    
    return self;
}


- (NSString*) stringBetweenString:(NSString*)string start:(NSString*)start andend:(NSString*)end {
    if(start == nil) {
        NSRange targetRange;
        targetRange.location = 0;
        NSRange endRange = [string rangeOfString:end];
        if(endRange.location == NSNotFound) {
            return string;
        }
        targetRange.length = endRange.location - 1;
        return [string substringWithRange:targetRange];
    }
    NSRange startRange = [string rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [string length] - targetRange.location;
        NSRange endRange = [string rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [string substringWithRange:targetRange];
        }
    }
    return string;
}

- (NSString*) fixHtml:(NSString*)rawHtml {
    NSString* output = [NSString stringWithFormat:@"%@%@%@", @"<table style=\"font-size:60px\"><tr>", rawHtml, @"</tr></table>"];
    return [output stringByReplacingOccurrencesOfString:@"<img" withString:@"<img width=160 height=160"];
}

- (void) setStartAndEndDate: (NSString*)date timeAndDay:(NSString*)timeAndDay {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *shortDateFormatter = [[NSDateFormatter alloc] init];
    [shortDateFormatter setDateFormat:@"MMM DD"];
    NSArray *dateComponents = [date componentsSeparatedByString:@" - "];
    NSString *startDate = [dateComponents objectAtIndex:0];
    NSString *endDate = nil;
    if([dateComponents count] > 1) {
        endDate = [dateComponents objectAtIndex:1];
    }
    
    NSDate *shortStartDate = [shortDateFormatter dateFromString:startDate];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentDateComponents = [calendar components:NSYearCalendarUnit fromDate:currentDate];
    NSDateComponents *startDateComponents = [calendar components:NSYearCalendarUnit fromDate:shortStartDate];
    if(startDateComponents.month < currentDateComponents.month) {
        startDateComponents.year = currentDateComponents.year + 1;
    }
    //NSString *fullDate = [date stringByAppendingString:@" 2014"];
    //NSDate* formattedDate = [dateFormatter dateFromString:date];
    //self.startDate = formattedDate;
}

@end
