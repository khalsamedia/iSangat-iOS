//
//  iSangatDetailViewController.m
//  isangat
//
//  Created by Ravneet Khalsa on 8/1/14.
//  Copyright (c) 2014 isangat. All rights reserved.
//

#import "iSangatDetailViewController.h"

@implementation iSangatDetailViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)setRawHtml:(NSString *)rawHtml {
    _rawHtml = rawHtml;
    if(_rawHtml) {
        [(UIWebView*)self.view loadHTMLString:_rawHtml baseURL:nil];
    }
}

@end
