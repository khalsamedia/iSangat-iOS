//
//  iSangatDetailViewController.h
//  isangat
//
//  Created by Ravneet Khalsa on 8/1/14.
//  Copyright (c) 2014 isangat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface iSangatDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic, copy) NSString *rawHtml;

@end
