//
//  ViewController.m
//  TwitterAPI
//
//  Created by A's macAir on 1/1/15.
//  Copyright (c) 2015 Abdoulaye Diallo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) NSArray * theArray;
@end

@implementation ViewController


#pragma mark-TABLE VIEW DELEGATES
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.theArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"cellID";
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(cell==nil)
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *theTweet=self.theArray[indexPath.row];
    cell.textLabel.text=theTweet[@"text"];
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




-(void) viewDidLoad{
    [super viewDidLoad];
    
    [self accountType];
}








-(void) accountType{

    ACAccountStore *account=[[ACAccountStore alloc] init];
    
    ACAccountType *accountType=[account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options: nil completion:^(BOOL granted, NSError *error) {
        if(granted==YES){
            NSArray *arrayOfAccounts=[account accountsWithAccountType:accountType];
            
            if([arrayOfAccounts count]>0){
                
                ACAccount *twitterAccount=[arrayOfAccounts lastObject];
                NSURL *requestURL=[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                NSMutableDictionary * elements=[[NSMutableDictionary alloc] init];
                [elements setObject:@"100" forKey:@"count"];
                [elements setObject:@"1" forKey:@"include_entities"];
                SLRequest *thePosts=[SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:elements];
                thePosts.account=twitterAccount;
                [thePosts performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    self.theArray=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                }];
                if(self.theArray !=0)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
            }
        }
        else{
            NSLog(@"%@",[error  localizedDescription ]);
        }
        
        
        
    }];
}






@end
