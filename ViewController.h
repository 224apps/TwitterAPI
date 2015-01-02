//
//  ViewController.h
//  TwitterAPI
//
//  Created by A's macAir on 1/1/15.
//  Copyright (c) 2015 Abdoulaye Diallo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import<Social/Social.h>
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

