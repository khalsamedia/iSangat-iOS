//
//  iSangatRecordingsController.m
//  isangat
//
//  Created by Ravneet Khalsa on 8/6/14.
//  Copyright (c) 2014 isangat. All rights reserved.
//

#import "iSangatRecordingsController.h"

@interface iSangatRecordingsController()

@property (nonatomic, strong) NSURL* recordingUrl;

@end

@implementation iSangatRecordingsController


-(instancetype) init {
    self = [super init];
    if(self) {
        self.recordingUrl = [NSURL URLWithString:@"http://isangat.wix.com/isangatmedia#!recordings-from-local-keertans/c1yi7"];
       // self.recordingUrl = [NSURL URLWithString:@"http://1drv.ms/1oHYxf3"];
    }
    return self;
}

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)viewDidLoad {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.recordingUrl];
    [(UIWebView*)self.view loadRequest:urlRequest];
}

@end
