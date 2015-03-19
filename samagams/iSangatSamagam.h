//
//  iSangatSamagam.h
//  isangat
//
//  Created by Ravneet Khalsa on 7/31/14.
//  Copyright (c) 2014 isangat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iSangatSamagam : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *rawHtml;

- (instancetype) initWithRawData : (NSString*) date
                       firstLine : (NSString*)firstLine
                      secondLine : (NSString*)secondLine
                        boldText : (NSString*)boldText
                         gmapUrl : (NSString*)gmapUrl
                         rawHtml : (NSString*)rawHtml;

@end
