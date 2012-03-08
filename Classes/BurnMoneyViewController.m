//
//  BurnMoneyViewController.m
//  BurnMoney
//
//  Created by Jesse Daugherty on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BurnMoneyViewController.h"

@implementation BurnMoneyViewController

@synthesize username;
@synthesize totalBurned;
@synthesize toBeBurned;
@synthesize leaderboardEntries;

- (void)alertView:(UIAlertView *)alreadyAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alreadyAlertView.tag == 1) {
		if (buttonIndex == 1)
		{
			[self BurnYES];
		}
    }
    if (alreadyAlertView.tag ==2) {
       
        if (buttonIndex ==1) {
            [self getUsername];
        }
        if (buttonIndex ==0) {
            NSUserDefaults      *burner;
            burner = [NSUserDefaults standardUserDefaults];
            [burner setInteger:0 forKey:@"launchCount"];
            [burner synchronize];
        }
        
    }
    
}



-(IBAction)Burn1D{
	toBeBurned = 1;
	burnMessage = @"Do it. Prove your wealth!";

	[self BurnXD];
}


-(IBAction)Burn5D{
	toBeBurned = 5;
	burnMessage = @"You've got money to blow!";

	[self BurnXD];

}


-(IBAction)Burn20D{
	toBeBurned = 20;
	burnMessage = @"20 bucks is nothing!";
	[self BurnXD];

}


-(IBAction)Burn100D{
	toBeBurned = 100;
	burnMessage = @"Goodbye, Benjamin!";
	[self BurnXD];

}


-(IBAction)Burn1000D{
	toBeBurned = 1000;
	burnMessage = @"You are unbelievably rich.";
	[self BurnXD];

}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	SKProduct *validProduct = nil;
	int count = [response.products count];
	if (count > 0) {
		validProduct = [response.products objectAtIndex:0];
	} else if (!validProduct) {
		NSLog(@"No products available");
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchasing:
				
				break;
				
			case SKPaymentTransactionStatePurchased:
				
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				
                [self burnYES3];

                
				break;
				
			case SKPaymentTransactionStateRestored:
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
				
				break;
				
			case SKPaymentTransactionStateFailed:
					NSLog(@"An error encounterd");
				
				[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self   burnYES4];

				break;
		}
	}
}




-(void)BurnYES{
	
	[UIView animateWithDuration:.7
					 animations:^{ 
						 buttonsLabelsView.alpha = 0;
                         totalBurnedLabel.alpha = 0;
					 } 
					 completion:^(BOOL finished){
						 [self burnYES2];
					 }];	
	
}
	

-(void)burnYES2 {
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:[NSString stringWithFormat:@"burn%d",toBeBurned]];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] addPayment:payment];

    
}


- (NSString *) submitScore:(float) theScore username:(NSString *) username1 {
    
	NSString * udid = [[UIDevice currentDevice] uniqueIdentifier];
	NSString * secret = @"12345";
	username1 = [username1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	NSString *urlString = [NSString stringWithFormat:@"http://burnmoney.zxq.net/put_score.php?secret=%@&udid=%@&name=%@&score=%f",
						   secret,udid,username1,theScore];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSError * e;
	NSData	     *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(IBAction)showLeaderboard {
    touchButtonLabel.hidden=YES;
    NSURL *url = [[NSURL alloc] initWithString:@"http://burnmoney.zxq.net/get_scorescopy.php"];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    
    BOOL success = [xmlParser parse];
    
    if(success)
        NSLog(@"No Errors");
    else
        NSLog(@"Error Error Error!!!");

}

-(IBAction)hideLeaderboard {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    leaderboardView.alpha=0;
    [UIView commitAnimations];
    leaderboardView.hidden=YES;
    
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"entries"]) {
        //Initialize the array.
        leaderboardEntries = [[NSMutableArray alloc] init];
        numberInXML = 0;
    }
    else if([elementName isEqualToString:@"entry"]) {
        entry = [[NSMutableDictionary alloc]init];
        
        //Extract the attribute here.
        numberInXML++;
        [entry setObject:[NSNumber numberWithInt:numberInXML] forKey:@"id"];
        
        NSLog(@"Reading id value :%i", numberInXML);
    }
    
    NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    NSLog(@"Processing Value: %@", currentElementValue);
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"entries"])
        if (richerThanYou==0) {
            leaderboardLabel.text = [NSString stringWithFormat:@"%i people have burned", numberInXML];
            TitleLabel.text = @"Think You're RICH?";  

        }
        [leaderboardTable reloadData];
        [self populateLeaderboard];
        
    
    if([elementName isEqualToString:@"entry"]) {
        [leaderboardEntries addObject:entry];
        [entry release];
        entry = nil;
    }
    else
    {
        
    NSString *tempString = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([[[UIDevice currentDevice] uniqueIdentifier]isEqualToString:tempString])
        {
            richerThanYou = numberInXML;
            if (richerThanYou==1) {
                leaderboardLabel.text= @"Nobody has burned";
              TitleLabel.text = @"YOU ARE SO RICH!";  
            }
            if (richerThanYou!=1) {
                if (richerThanYou ==2){
                    leaderboardLabel.text =@"1 person has burned";
                }
                leaderboardLabel.text = [NSString stringWithFormat:@"%i people have burned", richerThanYou-1];
                TitleLabel.text = @"Think You're RICH?";  

            }
        }
    
        [entry setValue:currentElementValue forKey:elementName];
    
    [currentElementValue release];
    currentElementValue = nil;
    }
}


-(void)populateLeaderboard {
    
   	leaderboardView.hidden=NO;
    leaderboardView.alpha=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.6];
    leaderboardView.alpha=1;
    [UIView commitAnimations];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [leaderboardEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
	if (cell == nil) 
    { 
        cell = [[[UITableViewCell alloc]
								initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
	}
	NSUInteger row = [indexPath row]; 
    NSString *tempString = [[[leaderboardEntries objectAtIndex:row]objectForKey:@"score"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.textLabel.text = [[[[leaderboardEntries objectAtIndex:row]objectForKey:@"name"]stringByAppendingString:@": $"]stringByAppendingString:tempString];
    NSString *atempString = [[[leaderboardEntries objectAtIndex:row]objectForKey:@"udid"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cell.textLabel.textColor = [UIColor blackColor];
    if ([atempString isEqualToString:[[UIDevice currentDevice] uniqueIdentifier]]) {
        cell.textLabel.textColor = [UIColor greenColor];
    }
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    [tableView setSeparatorColor:[UIColor redColor]];
    return cell;
}




-(void)burnYES3 {

	totalBurned = totalBurned + toBeBurned;

    [self submitScore:totalBurned username:username];

    NSUserDefaults      *burner;
    
    burner = [NSUserDefaults standardUserDefaults];
    [burner setInteger:totalBurned forKey:@"totalBurned"];
    [burner synchronize];
    
	UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",toBeBurned] ofType:@"jpg"]];
	billView.hidden=NO;
	billView.image = img; 
	billView.frame = CGRectMake(0, 0, 320, 150);
	[billView setCenter:CGPointMake(160, -75)];
	
	[UIView animateWithDuration:3.5 
					 animations:^{ 
						 billView.center = CGPointMake (160, 320);
						 billView.frame = CGRectMake(billView.center.x, billView.center.y, 0, 0);
					 }
					 completion:^(BOOL finished){
						 [self burnYES4];
					 }];

}

-(void)burnYES4  {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	buttonsLabelsView.alpha = 1;
    totalBurnedLabel.alpha = 1;
	totalBurnedLabel.text = [NSString stringWithFormat:@"You've burned $%d",totalBurned];

	[UIView commitAnimations];
	billView.hidden=YES;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://burnmoney.zxq.net/get_scorescopy.php"];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
	
}




-(void)BurnXD{
	NSString *temp1 = [NSString stringWithFormat:@"You want to burn $%d?", toBeBurned];
	UIAlertView *confirmBurn = [[UIAlertView alloc] initWithTitle:temp1 message:burnMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Burn It", nil];
	[confirmBurn setTag:1];
    [confirmBurn show];
	[confirmBurn release];

}

-(void)getUsername {
    usernameView.alpha = 0;
    usernameView.hidden=NO;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
    usernameView.alpha=1;
	[UIView commitAnimations];
    
    
}


-(IBAction)submitUsername {
    [usernameTextField resignFirstResponder];
    username = usernameTextField.text;
    NSUserDefaults      *burner;
    burner = [NSUserDefaults standardUserDefaults];
    [burner setObject:username forKey:@"username"];
    [burner synchronize]; 
   
    buttonsLabelsView.alpha=0;
    buttonsLabelsView.hidden=NO;
    totalBurnedLabel.alpha=0;
    totalBurnedLabel.hidden=NO;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
    usernameView.alpha=0;
    buttonsLabelsView.alpha=1;
    totalBurnedLabel.alpha=1;
    [UIView commitAnimations];
    usernameView.hidden=YES;

    NSURL *url = [[NSURL alloc] initWithString:@"http://burnmoney.zxq.net/get_scorescopy.php"];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
    
}


-(void)updateBurnRanking {
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://burnmoney.zxq.net/get_scorescopy.php"];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [xmlParser setDelegate:self];
    
    BOOL success = [xmlParser parse];

    if(success)
        NSLog(@"No Errors");
    else
        NSLog(@"Error Error Error!!!");
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   
    
	fireView.animationImages = [NSArray arrayWithObjects:  
								[UIImage imageNamed:@"Fire1.gif"],
								[UIImage imageNamed:@"Fire2.gif"],
								[UIImage imageNamed:@"Fire3.gif"],
								[UIImage imageNamed:@"Fire4.gif"],
								[UIImage imageNamed:@"Fire5.gif"],
								[UIImage imageNamed:@"Fire6.gif"],
								[UIImage imageNamed:@"Fire7.gif"],
								[UIImage imageNamed:@"Fire8.gif"],
								[UIImage imageNamed:@"Fire9.gif"],
								[UIImage imageNamed:@"Fire10.gif"],
								[UIImage imageNamed:@"Fire11.gif"],
								[UIImage imageNamed:@"Fire12.gif"],
								[UIImage imageNamed:@"Fire13.gif"],
								[UIImage imageNamed:@"Fire14.gif"],
								[UIImage imageNamed:@"Fire15.gif"],
								[UIImage imageNamed:@"Fire16.gif"],
								[UIImage imageNamed:@"Fire17.gif"], nil];
	
	
	fireView.animationDuration = 1.5;
	// repeat the annimation forever
	fireView.animationRepeatCount = 0;
	// start animating
	[fireView startAnimating];
	// add the animation view to the main window 	
	
    billView.hidden=YES;
    leaderboardView.hidden=YES;
    usernameView.hidden=YES;
	
	[super viewDidLoad];

    
    if ([SKPaymentQueue canMakePayments]) {
		NSLog(@"Parental-controls are disabled");
		
		SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:@"burn1",@"burn5",@"burn20",@"burn100",@"burn1000", nil]];
		productsRequest.delegate = self;
		[productsRequest start];
	} else {
		NSLog(@"Parental-controls are enabled");
    }

    
    NSUserDefaults      *burner;
    int                 launchCount;
    
    burner = [NSUserDefaults standardUserDefaults];
    launchCount = [burner integerForKey:@"launchCount" ] + 1;
    totalBurned = [burner integerForKey:@"totalBurned"];
    username = [burner objectForKey:@"username"];
    [burner setInteger:totalBurned forKey:@"totalBurned"];
    [burner setInteger:launchCount forKey:@"launchCount"];
    [burner synchronize];
    
    totalBurnedLabel.text = [NSString stringWithFormat:@"You've burned $%d",totalBurned];
    
    NSLog(@"number of times: %i this app has been launched", launchCount);
    
    if ( launchCount == 1 )
    {
        buttonsLabelsView.hidden=YES;
        totalBurnedLabel.hidden=YES;
        NSLog(@"this is the FIRST LAUNCH of the app");
        
        UIAlertView *firstLaunch = [[UIAlertView alloc] initWithTitle:@"Welcome to Burn Money" message:@"By using this app, you understand that you are burning real money. Every time money is \"burned\", the corresponding amount is charged to your iTunes account.  \nThis app is a contest between the wealthy. If you cannot afford to waste money, leave the app. \nDo you have money to blow?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes, Begin", nil];
        [firstLaunch    show];
        [firstLaunch setTag:2];
        [firstLaunch release];
        
    
    }
    
    if (launchCount != 1)
    {
        [self updateBurnRanking];

    }
    

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
