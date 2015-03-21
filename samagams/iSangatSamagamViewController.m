//
//  iSangatSamagamViewController.m
//  isangat
//
//  Created by Ravneet Khalsa on 7/29/14.
//  Copyright (c) 2014 isangat. All rights reserved.
//

#import "iSangatSamagamViewController.h"
#import "TFHpple.h"
#import "iSangatSamagam2.h"
#import "iSangatDetailViewController.h"
#import "iSangatRecordingsController.h"
#import "iSangatItemCell.h"
#import "iSangatNotificationManager.h"

@interface iSangatSamagamViewController() <NSURLSessionDataDelegate>

@property NSMutableArray *samagams;

@end

@implementation iSangatSamagamViewController

- (instancetype) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        emailButton.frame = CGRectMake(0, 0, 80, 30);
        [emailButton setTitle:@"Contact" forState:UIControlStateNormal];
        [emailButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:emailButton];
        
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
        UIButton *showRecordingsButton  = [UIButton buttonWithType:UIButtonTypeSystem];
        showRecordingsButton.frame = CGRectMake(0, 0, 110, 30);
        [showRecordingsButton setTitle:@"Recordings" forState:UIControlStateNormal];
        
        [showRecordingsButton addTarget:self action:@selector(oldRecordings:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:showRecordingsButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        [self loadSamagams];
    }
    
    return self;
}


- (void) loadSamagams {
    NSString *iSangatUrl = @"http://www.isangat.org/json.php";
    NSURL *url = [NSURL URLWithString:iSangatUrl];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    NSArray* allPrograms = json[@"programs"];
    
    NSMutableArray *samagamsCopy = [[NSMutableArray alloc] initWithCapacity: [allPrograms count]];
    
    for (NSDictionary* program in allPrograms) {
        @try {
            NSString* id = program[@"id"];
            NSString* sd = program[@"sd"];
            NSString* ed = program[@"ed"];
            NSString* title = program[@"title"];
            NSString* subtitle = program[@"subtitle"];
            NSString* address = program[@"address"];
            NSString* phone = program[@"phone"];
            
            //Don't add empty programs
            if ([title length] == 0 || [subtitle length] == 0) {
                continue;
            }
            
            iSangatSamagam2 *samagam = [[iSangatSamagam2 alloc] init:id title:title subTitle:subtitle startDate:sd endDate:ed address:address phone:phone];
            
            [samagamsCopy addObject:samagam];
            
        }
        @catch (NSException *ex) {
            NSLog(@"%@", ex.reason);
            continue;

        }
    }
    
    [[[iSangatNotificationManager alloc] init] scheduleNotifications:samagamsCopy];
    
    _samagams = samagamsCopy;
    [[self tableView] reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_samagams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    iSangatItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iSangatItemCell" forIndexPath:indexPath];
  
    UIView *cellContentView = cell.contentView;
    
    iSangatSamagam2 *samagam = [_samagams objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = samagam.title;
    cell.subTitleLabel.text = samagam.subTitle;
    cell.dateLabel.text = samagam.displayDate;
    
    cell.directionsButton.tag = indexPath.row;
    cell.phoneButton.tag = indexPath.row;
    
    [cell.directionsButton addTarget:self action:@selector(directions:) forControlEvents:UIControlEventTouchUpInside];
    [cell.phoneButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row %2 != 0) {
        cell.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:246.0/255.0 blue:252.0/255.0 alpha:255.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    [cellContentView addSubview:cell.titleLabel];
    [cellContentView addSubview:cell.subTitleLabel];
    [cellContentView addSubview:cell.directionsButton];
    [cellContentView addSubview:cell.phoneButton]; 
    
    return  cell;
}

- (IBAction)directions: (id)sender {
    UIButton *directionsBtn = (UIButton*)sender;
    NSInteger idx = directionsBtn.tag;
    iSangatSamagam2 *samagam = [_samagams objectAtIndex:idx];
    NSString *mapUrl = @"http://maps.apple.com/?daddr=";
    NSString *samagamAddrUrlStr = [mapUrl stringByAppendingString:samagam.address];
    NSURL *samagamAddrUrl = [NSURL URLWithString:samagamAddrUrlStr];
    [[UIApplication sharedApplication] openURL:samagamAddrUrl];
}

- (IBAction)call:(id)sender {
    UIButton *phoneBtn = (UIButton*)sender;
    NSInteger idx = phoneBtn.tag;
    iSangatSamagam2 *samagam = [_samagams objectAtIndex:idx];
    NSString* phoneStr = [@"tel:" stringByAppendingString:samagam.phone];
    NSURL *phoneUrl = [NSURL URLWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneUrl];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

-(IBAction)sendEmail  :(id)sender {
    //Change to sevaa@isangat.org
    [self sendEmailTo:@"ravneet_ee@yahoo.com"];
}

-(void)sendEmailTo:(NSString*) to {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.delegate = self;
        [mailComposeVC setSubject:@"Waheguru"];
        [mailComposeVC setToRecipients:[NSArray arrayWithObject:to]];
        [mailComposeVC setMessageBody:@"Waheguru ji kaa Khalsa Waheguru ji kee Fateh" isHTML:NO];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)oldRecordings:(id)sender {
    iSangatRecordingsController *recordingsVC = [[iSangatRecordingsController alloc] init];
    
    [self.navigationController pushViewController:recordingsVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"iSangatItemCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"iSangatItemCell"];
}



@end
