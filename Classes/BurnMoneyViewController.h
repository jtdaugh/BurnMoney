//
//  BurnMoneyViewController.h
//  BurnMoney
//
//  Created by Jesse Daugherty on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface BurnMoneyViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate,UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver, NSXMLParserDelegate> {
	IBOutlet UIImageView	*fireView;
	IBOutlet UIImageView	*billView;
    
	IBOutlet UIView			*buttonsLabelsView;
    IBOutlet UIView         *leaderboardView;
    IBOutlet UIView         *usernameView;
    
    IBOutlet UITableView    *leaderboardTable;
    IBOutlet UITableViewCell *leaderboardEntryCell;
    
	IBOutlet UILabel		*leaderboardLabel;
	IBOutlet UILabel		*leaderboardLabel2;
	IBOutlet UILabel		*totalBurnedLabel;
    IBOutlet UILabel        *TitleLabel;
    IBOutlet UILabel        *touchButtonLabel;
    
    IBOutlet UITextField        *usernameTextField;
    int numberInXML;
	int totalBurned;
	int toBeBurned;
    int richerThanYou;
    
	NSString *burnMessage;
    NSString *username;
    NSMutableString *currentElementValue;
    NSMutableDictionary *entry;
    NSMutableArray *leaderboardEntries;
}

-(IBAction)showLeaderboard;
-(IBAction)hideLeaderboard;

-(IBAction)Burn1D;
-(IBAction)Burn5D;
-(IBAction)Burn20D;
-(IBAction)Burn100D;
-(IBAction)Burn1000D;

-(IBAction)submitUsername;


- (NSString *) submitScore:(float) theScore username:(NSString *) username;
-(void)getUsername;
-(void)populateLeaderboard;

-(void)updateBurnRanking;

-(void)BurnXD;
-(void)BurnYES;
-(void)burnYES2;
-(void)burnYES3;
-(void)burnYES4;

@property (nonatomic, retain) NSString *username;
@property (nonatomic) int totalBurned;
@property (nonatomic) int toBeBurned;
@property (nonatomic, retain) NSMutableArray *leaderboardEntries;

@end

