//
//  iSangatSamagam2.h
//  isangat
//
//  Created by Ravneet Khalsa on 3/9/15.
//  Copyright (c) 2015 isangat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iSangatSamagam2 : NSObject <NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString* displayDate;

- (instancetype) init : (NSString*) id
                          title : (NSString*) title
                       subTitle : (NSString*)subTitle
                      startDate : (NSString*)startDate
                        endDate : (NSString*)endDate
                        address : (NSString*)address
                        phone   : (NSString*)phone;


@end
